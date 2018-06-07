//
//  SFaceCompare.swift
//  SFaceCompare
//
//  Created by Soft Project on 6/6/18.
//

import Vision
import SameFace

public class SFaceCompare {
  
  public static let opncvwrp: OpenCVWrapper = OpenCVWrapper()
  private let operationQueue: OperationQueue
  let firstImage: UIImage
  let secondImage: UIImage
  
  public init(on firstImage: UIImage, and secondImage: UIImage ){
    self.firstImage = firstImage
    self.secondImage = secondImage
    self.operationQueue = OperationQueue()
    self.operationQueue.qualityOfService = .background
    //    self.opncvwrp = OpenCVWrapper()
  }
  
  /**
   Compares faces from the two input image.
   
   - parameter succes: Handler will call if Faces are the same.
   - parameter failure: Handler will call if some error occurred.
   
   */
  public func compareFaces(succes: @escaping ([DetectionResult])->(), failure: @escaping (Error) -> () ) { //  func areSameFaces(on firstImage: UIImage, and secondImage: UIImage) {
    
    guard let firstFaceDetectionOperation = FaceDetectionOperation(input: firstImage, objectsCountToDetect: 1,
                                                                   orientation: CGImagePropertyOrientation.up) else {
                                                                    Logger.e("Can not instantiate face detection for photoOfDidinaID of type UIImage")
                                                                    return //false
    }
    
    guard let secondFaceDetectionOperation = FaceDetectionOperation(input: secondImage, objectsCountToDetect: 1,
                                                                    orientation: CGImagePropertyOrientation.up) else {
                                                                      Logger.e("Can not instantiate face detection for photoOfDidinaID of type UIImage")
                                                                      return //false
    }
    
    // Creating final operation
    let finishOperation = BlockOperation {
      // Checking results from firstFaceDetectionOperation
      guard let firstFaceOperationResults = firstFaceDetectionOperation.operationResult?.first else {
        DispatchQueue.main.async {
          let error = SFaceError.emptyResultsIn("Face detection Operation", reason: nil)
          failure(error)
        }
        return
      }
      
      // Checking results from secondFaceDetectionOperation
      guard let secondFaceOperationResults = secondFaceDetectionOperation.operationResult?.first else {
        DispatchQueue.main.async {
          let error = SFaceError.emptyResultsIn("Face detection Operation", reason: nil)
          failure(error)
        }
        return
      }
      
      // Processing results from operations
      /*
       1. Get aligned faces
       2. Pass them through ML model
       3. Return results
       */
      guard let firstAlignedFace = SFaceCompare.opncvwrp.faceAlign(firstFaceOperationResults.image),
        let secondAlignedFace = SFaceCompare.opncvwrp.faceAlign(secondFaceOperationResults.image) else {
          DispatchQueue.main.async {
            let error = SFaceError.wrongFaces(reason: "Faces can not be aligned. Try other images")
            failure(error)
          }
          return
      }
      do {
        let net = Faces()
        guard let firstPixelBuffer = firstAlignedFace.cvPixelBuffer,
          let secondPixelBuffer = secondAlignedFace.cvPixelBuffer else {
            DispatchQueue.main.async {
              let error = SFaceError.wrongFaces(reason: "Can not extract cvPixelBuffer to one of image. Try other images.")
              failure(error)
            }
            return
        }
      
        // neural networks answers getting
        let firstOutput = try net.prediction(data: firstPixelBuffer).output
        let secondOutput = try net.prediction(data: secondPixelBuffer).output
        var result = 0.0
        
        // network outputs differece calculating
        for idx in 0..<128 {
          result += (Double(truncating: firstOutput[idx]) - Double(truncating: secondOutput[idx]))
            * (Double(truncating: firstOutput[idx]) - Double(truncating: secondOutput[idx]))
        }
        print(result)
        if result < 1.0 {
          DispatchQueue.main.async {
            succes([firstFaceOperationResults, secondFaceOperationResults])
          }
        } else {
          DispatchQueue.main.async {
            let error = SFaceError.wrongFaces(reason: "Faces are not the same. Matching coof is \(result)")
            failure(error)
          }
        }
      } catch {
        Logger.e(error.localizedDescription)
        DispatchQueue.main.async {
          failure(error)
        }
      }
    }
    
    // Adding operations and dependencies
    finishOperation.addDependency(firstFaceDetectionOperation)
    finishOperation.addDependency(secondFaceDetectionOperation)
    
    operationQueue.addOperations([firstFaceDetectionOperation,
                                  secondFaceDetectionOperation,
                                  finishOperation], waitUntilFinished: false)
  }
}
