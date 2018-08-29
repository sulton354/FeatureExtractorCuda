/*
 * ImageFeatureComputer.cpp
 *
 *  Created on: 26/ago/2018
 *      Author: simone
 */

#include <iostream>
#include <fstream>
#include <sys/stat.h>
#include "ImageFeatureComputer.h"


ImageFeatureComputer::ImageFeatureComputer(const ProgramArguments& progArg)
:progArg(progArg){}


void checkOptionCompatibility(ProgramArguments& progArg, const Image img){
    int imageSmallestSide = img.getRows();
    if(img.getColumns() < imageSmallestSide)
        imageSmallestSide = img.getColumns();
    if(progArg.windowSize > imageSmallestSide){
        cout << "WARNING! The window side specified with the option -w"
                "exceeds the smallest dimension (" << imageSmallestSide << ") of the image read!" << endl;
        cout << "Window side is corrected to (" << imageSmallestSide << ")" << endl;
        progArg.windowSize = imageSmallestSide;
    }

}

void ImageFeatureComputer::compute(){
	cout << "* LOADING image * " << endl;

	// Image from imageLoader
	Image image = ImageLoader::readImage(progArg.imagePath, progArg.crop);
	ImageData imgData(image);
    cout << "* Image loaded * " << endl;
    checkOptionCompatibility(progArg, image);
	printExtimatedSizes(imgData);


	// Compute every feature
	cout << "* COMPUTING features * " << endl;
	vector<WindowFeatures> fs= computeAllFeatures(image.getPixels().data(), imgData);
	vector<vector<FeatureValues>> formattedFeatures = getAllDirectionsAllFeatureValues(fs);
	cout << "* Features computed * " << endl;

	// Save result to file
	cout << "* Saving features to files *" << endl;
	saveFeaturesToFiles(formattedFeatures);

	// Save feature images
	if(progArg.createImages){
		cout << "* Creating feature images *" << endl;
		// Compute how many features will be used for creating the image
		int numberOfRows = image.getRows() - progArg.windowSize + 1;
        int numberOfColumns = image.getColumns() - progArg.windowSize + 1;
        saveAllFeatureImages(numberOfRows, numberOfColumns, formattedFeatures);

	}
}

void checkMinimumMemoryOccupation(size_t featuresSize){
	cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, 0);
    size_t gpuMemory = prop.totalGlobalMem;
    if(featuresSize > gpuMemory){
    	cerr << "FAILURE ! Gpu doesn't have enough memory \
    to hold the results" << endl;
    exit(-1);
    }
}

void ImageFeatureComputer::printExtimatedSizes(const ImageData& img){
    int numberOfRows = img.getRows() - progArg.windowSize + 1;
    int numberOfColumns = img.getColumns() - progArg.windowSize + 1;
    int numberOfWindows = numberOfRows * numberOfColumns;
    int supportedFeatures = Features::getSupportedFeaturesCount();

    int featureNumber = numberOfWindows * supportedFeatures * progArg.numberOfDirections;
	cout << "\t- Size estimation - " << endl;
    cout << "\tTotal features number: " << featureNumber << endl;
    checkMinimumMemoryOccupation(featureNumber * sizeof(double));
    int featureSize = (((featureNumber * sizeof(double))
    	/1024)/1024); // in MB
    cout << "\tTotal features weight: " <<  featureSize << " MB" << endl;
}



/*
 * From linear to structured array of windowsFeature each containing
 * an array of directional features each containing all the feature values
*/
vector<vector<vector<double>>> formatOutputResults(const double* featureValues,
                                                   const int numberOfWindows, const int numberOfDirections, const int featuresCount){
    vector<vector<vector<double>>> output(numberOfWindows,
                                          vector<vector<double>>(numberOfDirections, vector<double> (featuresCount)));
    // How many double values fit into a window
    int windowResultsSize = numberOfDirections * featuresCount;
    // How many double values fit into a direction
    int directionResultSize = featuresCount;

    for (int k = 0; k < numberOfWindows; ++k) {
        int windowOffset = k * windowResultsSize;
        const double* windowResultsStartingPoint = featureValues + windowOffset;

        vector<vector<double>> singleWindowFeatures(numberOfDirections);

        for (int i = 0; i < numberOfDirections; ++i) {
            int directionOffset = i * directionResultSize;
            const double* dirResultsStartingPoint = windowResultsStartingPoint + directionOffset;
            // Copy each of the values
            vector<double> singleDirectionFeatures(dirResultsStartingPoint, dirResultsStartingPoint + directionResultSize);
            singleWindowFeatures[i] = singleDirectionFeatures;
        }
        output[k] = singleWindowFeatures;
    }
    return output;
}

int getCudaBlockSideX(){
	return 32;
}

int getCudaBlockSideY(){
	return 1;
}

// 1 line of threads
dim3 getBlockConfiguration()
{
	// TODO implement GPU architecture specific dimensioning 
	int ROWS = getCudaBlockSideY();
	int COLS = getCudaBlockSideX(); 
	assert(ROWS * COLS <= 1024);
	dim3 configuration(ROWS, COLS);
	return configuration;
}

int getGridSide(){
	cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, 0);
    return prop.multiProcessorCount;
}

// 1 line of blocks
dim3 getGridConfiguration()
{
    return dim3(1, getGridSide());
}

void cudaCheckError(cudaError_t err){
	if( err != cudaSuccess ) {
    	cerr << "ERROR: " << cudaGetErrorString(err) << endl;
    	exit(-1);
	}
}  


void queryGPUData(){
	cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, 0);
    printf("\t * GPU DATA *\n");
    printf("\tDevice name: %s\n", prop.name);
    printf("\tNumber of multiprocessors: %d\n", prop.multiProcessorCount);
    int nCores = prop.multiProcessorCount * 32;
    printf("\tMinimum total cores count: %d\n", nCores);
    printf("\tTotalGlobalMemory: %lu MB\n", prop.totalGlobalMem/1024/2014);
}


__global__ void computeFeatures(unsigned int * pixels, 
	ImageData img, Window windowData, WorkArea wa){
	// gridDim x is always 1
	int x = threadIdx.x; // 1 block per image row
	int y = blockIdx.y; // 1 row in each block
	// How many shift right for reaching the next window to compute
	int colsStride =  blockDim.x; 
	// How many shift down for reaching the next window to compute
	// gridDimY reflects the number of active blocks
	int rowsStride =  gridDim.y;
	int threadUniqueName = x + blockDim.x * y;
	for(int i = y; (i + windowData.side) <= img.getRows(); i+= rowsStride){
		for(int j = x; (j + windowData.side) <= img.getColumns() ; j+= colsStride){
			// TODO point the windowThread to the right memLocation in workArea
			// Create local window information
			Window actualWindow {windowData.side, windowData.distance,
                                 windowData.numberOfDirections, windowData.symmetric};
			// tell the window its relative offset (starting point) inside the image
			actualWindow.setSpacialOffsets(i, j);
			// tell the thread where its working area starts
			wa.increasePointers(threadUniqueName);
			// Launch the computation of features on the window
			WindowFeatureComputer wfc(pixels, img, actualWindow, wa);
		}
	}
}

/*
     * This method will compute all the features for every window for the
     * number of directions provided, in a window
     * By default all 4 directions are considered; order is 0->45->90->135°
     */
vector<WindowFeatures> ImageFeatureComputer::computeAllFeatures(unsigned int * pixels, const ImageData& img){
	queryGPUData();

	// Pre-Allocate working area
	Window windowData = Window(progArg.windowSize, progArg.distance, progArg.symmetric);

	// How many windows need to be allocated
    int numberOfWindows = (img.getRows() - progArg.windowSize + 1)
                          * (img.getColumns() - progArg.windowSize + 1);
    // How many directions need to be allocated for each window
    short int numberOfDirs = progArg.numberOfDirections;
    // How many feature values need to be allocated for each direction
    int featuresCount = Features::getSupportedFeaturesCount();

    // Pre-Allocate the array that will contain features
    double* featuresList = (double*) malloc(numberOfWindows * numberOfDirs * featuresCount * sizeof(double));
    // Allocate GPU space to contain results
    double* d_featuresList;
    cudaCheckError(cudaMalloc(&d_featuresList, numberOfWindows * numberOfDirs * featuresCount * sizeof(double)));

    // 	Pre-Allocate working area
    int extimatedWindowRows = windowData.side; // 0° has all rows
    int extimateWindowCols = windowData.side - (windowData.distance * 1); // at least 1 column is lost
    int numberOfPairsInWindow = extimatedWindowRows * extimateWindowCols;
    if(windowData.symmetric)
        numberOfPairsInWindow *= 2;

    // COPY the image pixels to the GPU
    unsigned int * d_pixels;
    cudaCheckError(cudaMalloc(&d_pixels, sizeof(unsigned int) * img.getRows() * img.getColumns()));
    cudaCheckError(cudaMemcpy(d_pixels, pixels,
    		sizeof(unsigned int) * img.getRows() * img.getColumns(),
    		cudaMemcpyHostToDevice));

    int numberOfThreadsPerBlock = getCudaBlockSideX() * getCudaBlockSideY();
    cout << "nthreadsperblock: " << numberOfThreadsPerBlock << endl;
    int numberOfBlocks = getGridSide();
    cout << "nblocks: " << numberOfBlocks << endl;

    int numberOfThreads = numberOfThreadsPerBlock * numberOfBlocks;
    // Each 1 of these data structures allow 1 thread to work
	GrayPair* d_elements;
	AggregatedGrayPair* d_summedPairs;
	AggregatedGrayPair* d_subtractedPairs;
	AggregatedGrayPair* d_xMarginalPairs;
	AggregatedGrayPair* d_yMarginalPairs;

	cudaCheckError(cudaMalloc(&d_elements, numberOfThreads * 
		sizeof(GrayPair) * numberOfPairsInWindow ));
	cudaCheckError(cudaMalloc(&d_summedPairs, numberOfThreads *
		sizeof(AggregatedGrayPair) * numberOfPairsInWindow));
	cudaCheckError(cudaMalloc(&d_subtractedPairs, numberOfThreads *
		sizeof(AggregatedGrayPair) * numberOfPairsInWindow));
	cudaCheckError(cudaMalloc(&d_xMarginalPairs, numberOfThreads *
		sizeof(AggregatedGrayPair) * numberOfPairsInWindow));
	cudaCheckError(cudaMalloc(&d_yMarginalPairs, numberOfThreads *
		sizeof(AggregatedGrayPair) * numberOfPairsInWindow));

    WorkArea wa(numberOfPairsInWindow, d_elements, d_summedPairs,
                d_subtractedPairs, d_xMarginalPairs, d_yMarginalPairs, d_featuresList);

	// START GPU WORK
	// ALways monodimensional Grids
	dim3 NBlocs = getBlockConfiguration();
	dim3 NThreadPerBlock = getGridConfiguration();
    computeFeatures<<<NBlocs, NThreadPerBlock>>>(d_pixels, img, windowData, wa);
    cudaError_t errSync  = cudaGetLastError();
	cudaError_t errAsync = cudaDeviceSynchronize();
	if (errSync != cudaSuccess) // Detect configuration launch errors
  		printf("Sync kernel error: %s\n", cudaGetErrorString(errSync));
	if (errAsync != cudaSuccess) // Detect kernel execution errors
  		printf("Async kernel error: %s\n", cudaGetErrorString(errAsync));

	// Copy back results from GPU
	cudaCheckError(cudaMemcpy(featuresList, d_featuresList,
			numberOfWindows * numberOfDirs * featuresCount * sizeof(double),
			cudaMemcpyDeviceToHost));

	// Give the data structure
    vector<vector<vector<double>>> output =
            formatOutputResults(featuresList, numberOfWindows, numberOfDirs, featuresCount);

	free(featuresList);
	cudaCheckError(cudaFree(d_summedPairs));
	cudaCheckError(cudaFree(d_subtractedPairs));
	cudaCheckError(cudaFree(d_xMarginalPairs));
	cudaCheckError(cudaFree(d_yMarginalPairs));
	return output;
}


/*
 * This method will generate a vector of vectors (1 for each direction) of features names and all their values found in the image
 * Es. <Entropy , (0.1, 0.2, 3, 4 , ...)>
 * Es. <IMOC, (-1,-2,0)>
 */
vector<vector<FeatureValues>> ImageFeatureComputer::getAllDirectionsAllFeatureValues(const vector<WindowFeatures>& imageFeatures){
	vector<FeatureNames> supportedFeatures = Features::getAllSupportedFeatures();
	int numberOfDirs = progArg.numberOfDirections;
	// Direzioni[] aventi Features[] aventi double[]
	vector<vector<FeatureValues>> output(numberOfDirs);

	// for each computed direction
	for (int j = 0; j < numberOfDirs; ++j) {
		// 1 external vector cell for each of the 18 features
		// each cell has all the values of that feature
		vector<FeatureValues> featuresInDirection(supportedFeatures.size());

		// for each computed window
		for (int i = 0; i < imageFeatures.size() ; ++i) {
			// for each supported feature
			for (int k = 0; k < supportedFeatures.size(); ++k) {
				FeatureNames actualFeature = supportedFeatures[k];
				// Push the value found in the output list for that direction
				featuresInDirection[actualFeature].push_back(imageFeatures.at(i).at(j).at(actualFeature));
			}
		}
		output[j] = featuresInDirection;
	}

	return output;
}

void ImageFeatureComputer::saveFeaturesToFiles(const vector<vector<FeatureValues>>& imageFeatures){
	string foldersPath[] ={ "Values0/", "Values45/", "Values90/", "Values135/"};
	int numberOfDirs = progArg.numberOfDirections;

	for (int i = 0; i < numberOfDirs; ++i) {
		// First create the the folder
		if (mkdir(foldersPath[i].c_str(), 0777) == -1) {
			if (errno == EEXIST) {
				// alredy exists
			} else {
				// something else
				cout << "cannot create save folder;  error:" << strerror(errno) << endl;
			}
		}
		saveDirectedFeaturesToFiles(imageFeatures[i], foldersPath[i]);
	}
}

void ImageFeatureComputer::saveDirectedFeaturesToFiles(const vector<FeatureValues>& imageDirectedFeatures,
		const string& outputFolderPath){
	vector<string> fileDestinations = Features::getAllFeaturesFileNames();

	// for each feature
	for(int i = 0; i < imageDirectedFeatures.size(); i++) {
		string newFileName(outputFolderPath); // create the right file path
		pair<FeatureNames , FeatureValues> featurePair = make_pair((FeatureNames) i, imageDirectedFeatures[i]);
		saveFeatureToFile(featurePair, newFileName.append(fileDestinations[i]));
	}
}

void ImageFeatureComputer::saveFeatureToFile(const pair<FeatureNames, vector<double>>& featurePair, string filePath){
	// Open the file
	ofstream file;
	file.open(filePath.append(".txt"));
	if(file.is_open()){
		for(int i = 0; i < featurePair.second.size(); i++){
			file << featurePair.second[i] << ",";
		}
		file.close();
	} else{
		cerr << "Couldn't save the feature values to file" << endl;
	}

}


/*
 * This method will create ALL the images associated with each feature,
 * for ALL the directions evaluated.
*/
void ImageFeatureComputer::saveAllFeatureImages(const int rowNumber,
		const int colNumber, const vector<vector<FeatureValues>>& imageFeatures){
	string foldersPath[] ={ "Images0/", "Images45/", "Images90/", "Images135/"};

	// For each direction
	for(int i=0; i < imageFeatures.size(); i++){
		// Create the folder
		if (mkdir(foldersPath[i].c_str(), 0777) == -1) {
			if (errno == EEXIST) {
				// alredy exists
			} else {
				// something else
				cout << "cannot create save folder;  error:" << strerror(errno) << endl;
			}
		}
		saveAllFeatureDirectedImages(rowNumber, colNumber, imageFeatures[i], foldersPath[i]);
	}
}

/*
 * This method will create ALL the images associated with each feature,
 * for 1 direction evaluated.
*/
void ImageFeatureComputer::saveAllFeatureDirectedImages(const int rowNumber,
		const int colNumber, const vector<FeatureValues>& imageDirectedFeatures, const string& outputFolderPath){

	vector<string> fileDestinations = Features::getAllFeaturesFileNames();

	// For each feature
	for(int i = 0; i < imageDirectedFeatures.size(); i++) {
		string newFileName(outputFolderPath);
		saveFeatureImage(rowNumber, colNumber, imageDirectedFeatures[i], newFileName.append(fileDestinations[i]));
	}
}

/*
 * This method will create an image associated with a feature,
 * for a single side evaluated;
*/
void ImageFeatureComputer::saveFeatureImage(const int rowNumber,
		const int colNumber, const FeatureValues& featureValues,const string& filePath){
	typedef vector<WindowFeatures>::const_iterator VI;

	int imageSize = rowNumber * colNumber;

	// Check if dimensions are compatible
	if(featureValues.size() != imageSize){
		cerr << "Fatal Error! Couldn't create the image; size unexpected " << featureValues.size();
		exit(-2);
	}

	// Create a 2d matrix of double elements
	Mat_<double> imageFeature = ImageLoader::createDoubleMat(rowNumber, colNumber, featureValues);
	// Transform to a format printable to file
    Mat convertedImage = ImageLoader::convertToGrayScale(imageFeature);
    ImageLoader::stretchAndSave(convertedImage, filePath);
}

