//
//  SFaceCompare.swift
//  SFaceCompare
//
//  Created by Bohdan Mihiliev on 6/6/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.

import Vision
import SameFace

public final class SFaceCompare {
  
  // MARK: - Properties
  private static let opncvwrp: OpenCVWrapper = OpenCVWrapper()
  private let firstImage: UIImage
  private let secondImage: UIImage
  private let operationQueue: OperationQueue
  
  // MARK: - Initializer
  /**
   Instantiates face compare process for given images.
   
   - parameter on: a UIImage where face to compare should be found.
   - parameter and: a UIImage where face to compare should be found.
   
   */
  public init(on firstImage: UIImage, and secondImage: UIImage ){
    self.firstImage = firstImage
    self.secondImage = secondImage
    self.operationQueue = OperationQueue()
    self.operationQueue.qualityOfService = .background
  }
  
  // MARK: - Public methods
  /**
   Loads important additional data for face normalization.
   ## Important Notes ##
   1. Can take some time.
   2. Is asynchronous inside.
   3. You should call this method ASAP
   */
  public static func prepareData(){  opncvwrp.loadData() }
  
  /**
   Compares faces detected on input images.

   - parameter succes: Handler will call if Faces are the same.
   - parameter failure: Handler will call if some error occurred.
   
   */
  public func compareFaces(succes: @escaping ([DetectionResult])->(),
                           failure: @escaping (Error) -> ()) {
    
    guard let firstFaceDetectionOperation = FaceDetectionOperation(input: firstImage, objectsCountToDetect: 1,
                                                                   orientation: CGImagePropertyOrientation.up) else {
                                                                    DispatchQueue.main.async {
                                                                      let error = SFaceError.canNotCreate("firstFaceDetectionOperation", reason: nil)
                                                                      failure(error)
                                                                    }
                                                                    return
    }
    
    guard let secondFaceDetectionOperation = FaceDetectionOperation(input: secondImage, objectsCountToDetect: 1,
                                                                    orientation: CGImagePropertyOrientation.up) else {
                                                                      DispatchQueue.main.async {
                                                                        let error = SFaceError.canNotCreate("secondFaceDetectionOperation", reason: nil)
                                                                        failure(error)
                                                                      }
                                                                      return
    }
    
    // Creating final operation
    let finishOperation = BlockOperation {
      // Checking results from firstFaceDetectionOperation
      guard let firstFaceOperationResults = firstFaceDetectionOperation.operationResult?.first else {
        DispatchQueue.main.async {
          let error = SFaceError.emptyResultsIn("Firs Face detection Operation",
                                                reason: nil)
          failure(error)
        }
        return
      }
      
      // Checking results from secondFaceDetectionOperation
      guard let secondFaceOperationResults = secondFaceDetectionOperation.operationResult?.first else {
        DispatchQueue.main.async {
          let error = SFaceError.emptyResultsIn("Second Face detection Operation",
                                                reason: nil)
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
              let error = SFaceError
                .wrongFaces(reason: "Can not extract cvPixelBuffer to one of image. Try other images.")
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
