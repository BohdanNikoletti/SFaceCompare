//
//  CIImage_CVMat.h
//  SFaceCompare
//
//  Created by Anton Khrolenko on 5/31/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

#ifndef CIImage_CVMat_h
#define CIImage_CVMat_h

#import <UIKit/UIKit.h>
#ifdef __cplusplus
#undef NO
#import <opencv2/opencv.hpp>

@interface CIImage (OpenCV)

- (cv::Mat)CVMat;
- (cv::Mat)CVMat3;  // no alpha channel
@end

#endif

#endif /* CIImage_CVMat_h */
