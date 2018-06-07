//
//  general.hpp
//  SFaceCompare
//
//  Created by Anton Khrolenko on 5/31/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

#ifndef general_hpp
#define general_hpp

#ifdef __cplusplus
#undef NO
#include <opencv2/opencv.hpp>
// thanks to Adrian Rosebrock

/**
 @brief Resizes input image to the output height or width with saving of the image proportion.
 @note Only width of height must be defined, other argument must be NULL.
 
 @param inputImage Image to resize.
 @param outputImage Result of the resize.
 @param width Width of the output image.
 @param height Height of the output image.
 @param inter Type of the interpolation according to the OpenCV types.
 */
void resize(cv::Mat &inputImage, cv::Mat &outputImage, int width=NULL, int height=NULL, int inter=cv::INTER_AREA);
#endif

#endif /* general_hpp */
