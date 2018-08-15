//
// Created by simone on 14/08/18.
//

#include "WorkArea.h"

void WorkArea::cleanup() {
    GrayPair voidElement; // 0 in each field
    AggregatedGrayPair voidAggregatedElement; // 0 in each field
    for (int i = 0; i < numberOfElements; ++i) {
        grayPairs[i] = voidElement;
        summedPairs[i] = voidAggregatedElement;
        subtractedPairs[i] = voidAggregatedElement;
        xMarginalPairs[i] = voidAggregatedElement;
        yMarginalPairs[i] = voidAggregatedElement;
    }
}