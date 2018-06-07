//
//  OpenCVWrapper.h
//  SFaceCompare
//
//  Created by Anton Khrolenko on 5/31/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//
#ifndef OpenCVWrapper_h
#define OpenCVWrapper_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIImage_CVMat.h"
#import "CIImage_CVMat.h"
//#import "opencv2/opencv.hpp"
#include "face.hpp"

@interface OpenCVWrapper : NSObject
/**
 @brief Aligns face for the further neural network processing in face comparing.
 @note Aligned face only fits 96x96 neural network input.
 
 @param inputImage Image with human face, which need to be aligned.
 @param needToFindFace Necessity of finding face on the input image.
 
 @return Aligned face image 96x96.
 */
- (UIImage*) faceAlign: (UIImage*) inputImage : (Boolean) needToFindFace;

- (UIImage*) faceAlign: (UIImage*) inputImage;
- (void) loadData;
@end
#endif
