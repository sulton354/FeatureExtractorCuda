//
// Created by simo on 25/07/18.
//

#include <iostream>
#include <fstream>
#include <sys/stat.h>
#include "ImageFeatureComputer.h"


ImageFeatureComputer::ImageFeatureComputer(const ProgramArguments& progArg)
:progArg(progArg)
{

}

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
	Image img = ImageLoader::readImage(progArg.imagePath, progArg.crop);
	cout << "* Image loaded * " << endl;
	checkOptionCompatibility(progArg, img);
	printExtimatedSizes(img);

	// Compute every feature
	cout << "* COMPUTING features * " << endl;
	vector<WindowFeatures> fs= computeAllFeatures(img);
	vector<vector<FeatureValues>> formattedFeatures = getAllDirectionsAllFeatureValues(fs);
	cout << "* Features computed * " << endl;

	// Print results to screen
	//printAllDirectionsAllFeatureValues(formattedFeatures);

	// Save result to file
	cout << "* Saving features to files *" << endl;
	saveFeaturesToFiles(formattedFeatures);

	// Save feature images
	if(progArg.createImages){
		cout << "* Creating feature images *" << endl;
		// Compute how many features will be used for creating the image
		int numberOfRows = img.getRows() - progArg.windowSize + 1;
        int numberOfColumns = img.getColumns() - progArg.windowSize + 1;
        saveAllFeatureImages(numberOfRows, numberOfColumns, formattedFeatures);

	}
}

void ImageFeatureComputer::printExtimatedSizes(const Image& img){
    int numberOfRows = img.getRows() - progArg.windowSize + 1;
    int numberOfColumns = img.getColumns() - progArg.windowSize + 1;

    int numberOfWindows = numberOfRows * numberOfColumns;
    int featureNumber = numberOfWindows * 18 * progArg.numberOfDirections;
	cout << "\t- Size estimation - " << endl;
    cout << "\tTotal features number: " << featureNumber << endl;
    int featureSize = (((featureNumber*8)/1024)/1024);
    cout << "\tTotal features weight: " <<  featureSize << " MB" << endl;
}

/*
     * This method will compute all the features for every window for the
     * number of directions provided, in a window
     * By default all 4 directions are considered; order is 0->45->90->135°
     */
vector<WindowFeatures> ImageFeatureComputer::computeAllFeatures(const Image& img){
	// TODO use this dimension in a static addressing way
	int numberOfWindows = (img.rows - progArg.windowSize + 1)
			* (img.columns - progArg.windowSize + 1);
	vector<WindowFeatures> featuresList;

	// Create data structure that incapsulate window parameters
	Window windowData = Window(progArg.windowSize, progArg.distance, progArg.symmetric);

	// Slide windows on the image
	for(int i = 0; (i + windowData.side) <= img.getRows(); i++){
		for(int j = 0; (j + windowData.side) <= img.getColumns() ; j++){
			// Create local window information
			Window actualWindow {windowData.side, windowData.distance,
								 windowData.symmetric};
			// tell the window its relative offset (starting point) inside the image
			actualWindow.setSpacialOffsets(i,j);
			// Launch the computation of features on the window
			WindowFeatureComputer wfc(img, actualWindow);
			WindowFeatures wfs = wfc.computeWindowFeatures(progArg.numberOfDirections);
			// save results
			featuresList.push_back(wfs);
		}
	}

	return featuresList;
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
 * This method will print the given vector of maps (1 for each direction)
 * of features names and all their values found in the image
 * Es. <Entropy , (0.1, 0.2, 3, 4 , ...)>
 * Es. <IMOC, (-1,-2,0)>
 */
void ImageFeatureComputer::printAllDirectionsAllFeatureValues(const vector<vector<FeatureValues>>& featureList)
{
	int numberOfDirs = progArg.numberOfDirections;
	typedef map<FeatureNames, vector<double>>::const_iterator MI;
	typedef vector<double>::const_iterator VI;
	// For each direction
	for (int i = 0; i < numberOfDirs; ++i) {
		Direction::printDirectionLabel(i);
		// for each computed feature
		for (int j = 0; j < featureList[i].size(); ++j) {
			Features::printFeatureName((FeatureNames) i); // print the feature label

			// Print all values
			for (int k = 0; k < featureList[i][j].size() ; ++k) {
				cout << featureList[i][j][k] << " ";
			}
			cout << endl;
		}
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

    Mat_<double> imageFeature = Mat(rowNumber, colNumber, CV_64F);
    // Copy the values into the image
    memcpy(imageFeature.data, featureValues.data(), imageSize * sizeof(double));

    Mat convertedImage = ImageLoader::convertToGrayScale(imageFeature);
    ImageLoader::stretchAndSave(convertedImage, filePath);
}




