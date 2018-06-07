//
//  face.hpp
//  SFaceCompare
//
//  Created by Anton Khrolenko on 5/31/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

#ifndef face_hpp
#define face_hpp

#ifdef __cplusplus
#undef NO
#include <opencv2/opencv.hpp>
#include <dlib/image_processing.h>
#include <dlib/opencv.h>
#include <dlib/image_processing/frontal_face_detector.h>
#include "general.hpp"

/**
 @brief Aligns face for the further neural network processing in face comparing.
 @note Aligned face only fits 96x96 neural network input.
 
 @param inputImage Image with human face, which need to be aligned.
 @param shapePredictor dlib shape predictor to find face landmarks.
 @param haarCascadeClassifier Haar Cascade Classifier to find face on the image if necessery.
 @param faceTemplate Constants for the 64 face landmarks for aligning.
 @param inputFaceRectangle Face rectangle coordinates on the image if it is known.
 
 @return Aligned face image 96x96.
 */
cv::Mat faceAlign(cv::Mat inputImage,
                  const dlib::shape_predictor& shapePredictor,
                  cv::CascadeClassifier haarCascadeClassifier,
                  cv::Point2f *faceTemplate,
                  cv::Rect inputFaceRectangle = cv::Rect()
                  );
#endif

#endif /* face_hpp */
