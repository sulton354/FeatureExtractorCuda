//
// Created by simo on 16/07/18.
//

#include <iostream>
#include "WindowFeatureComputer.h"



WindowFeatureComputer::WindowFeatureComputer(unsigned int * pxls,
		const ImageData& img, const Window& wd, WorkArea& wa): pixels(pxls),
		image(img), windowData(wd), workArea(wa){
}

/*
	This method will compute all the features for all numberOfDirections directions
 	provided by a parameter to the program ; the order is 0,45,90,135° ;
 	By default all 4 directions are evaluated
*/
vector<vector<double>> WindowFeatureComputer::computeWindowFeatures(const int numberOfDirections) {
	vector<vector<double>> featureList(numberOfDirections);

	vector<Direction> allDirections = Direction::getAllDirections();
	for(int i = 0; i < numberOfDirections; i++)
	{
		Direction actualDir = allDirections[i];
		FeatureComputer fc(pixels, image, actualDir.shiftRows, actualDir.shiftColumns,
						   windowData, workArea);
		vector<double> computedFeatures = fc.computeDirectionalFeatures();
		featureList[i] =  computedFeatures;
	}

	return featureList;
}

/*
	This method will print all the features for all 4 supported directions
*/
void WindowFeatureComputer::printAllDirectionsAllFeatures(const WindowFeatures &featureList){
	// The number of directions is deducted from size of WindowFeatures
	for(int i = 0; i < featureList.size(); i++) {
        Direction::printDirectionLabel(i);
        printSingleDirectionAllFeatures(featureList[i]);
	}
}

/*
	This method will print ALL the features for 1 supported direction with explanatory label
*/
void WindowFeatureComputer::printSingleDirectionAllFeatures(const vector<double>& featureList){
	Features::printAllFeatures(featureList);
	cout << endl;
}

