//
//  UIImage_CVMat.h
//  SFaceCompare
//
//  Created by Anton Khrolenko on 5/31/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

#ifndef UIImage_CVMat_h
#define UIImage_CVMat_h
#import <UIKit/UIKit.h>
#ifdef __cplusplus
#undef NO
#import <opencv2/opencv.hpp>

@interface UIImage (OpenCV)

- (cv::Mat)CVMat;
- (cv::Mat)CVMat3;  // no alpha channel
+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;
@end

#endif

#endif /* UIImage_CVMat_h */
