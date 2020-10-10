//
//  SFaceCompare.swift
//  SFaceCompare
//
//  Created by Bohdan Mihiliev on 6/6/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.

import Vision
import SameFace

public struct SFaceCompare {
  
  // MARK: - Properties
  private static let openCVwrapper: OpenCVWrapper = OpenCVWrapper()
  private let firstImage: UIImage
  private let secondImage: UIImage
  private let operationQueue: OperationQueue
  private let matchingCoefficient: Double
  // MARK: - Initializer
  /**
   Instantiates face compare process for given images.
   
   - parameter on: a UIImage where face to compare should be found.
   - parameter and: a UIImage where face to compare should be found.
   
   */
  public init(on firstImage: UIImage,
              and secondImage: UIImage,
              matchingCoefficient: Double = 1.0){
    self.firstImage = firstImage
    self.secondImage = secondImage
    self.matchingCoefficient = matchingCoefficient
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
  public static func prepareData() { openCVwrapper.loadData() }
  
  /**
   Compares faces detected on input images.
   
   - parameter success: Handler will call if Faces are the same.
   - parameter failure: Handler will call if some error occurred.
   
   */
  public func compareFaces(completion: @escaping (Result<CompareData, Error>) -> Void ) {
    
    guard let firstFaceDetectionOperation = FaceDetectionOperation(input: firstImage, objectsCountToDetect: 1,
                                                                   orientation: CGImagePropertyOrientation.up) else {
      DispatchQueue.main.async {
        let error = SFaceError.canNotCreate("firstFaceDetectionOperation", reason: nil)
        completion(.failure(error))
      }
      return
    }
    
    guard let secondFaceDetectionOperation = FaceDetectionOperation(input: secondImage, objectsCountToDetect: 1,
                                                                    orientation: CGImagePropertyOrientation.up) else {
      DispatchQueue.main.async {
        let error = SFaceError.canNotCreate("secondFaceDetectionOperation", reason: nil)
        completion(.failure(error))
      }
      return
    }
    
    // Creating final operation
    let finishOperation = BlockOperation {
      // Checking results from firstFaceDetectionOperation
      guard let firstFaceOperationResults = firstFaceDetectionOperation.operationResult?.first else {
        DispatchQueue.main.async {
          let error = SFaceError.emptyResultsIn("First Face detection Operation",
                                                reason: nil)
          completion(.failure(error))
        }
        return
      }
      
      // Checking results from secondFaceDetectionOperation
      guard let secondFaceOperationResults = secondFaceDetectionOperation.operationResult?.first else {
        DispatchQueue.main.async {
          let error = SFaceError.emptyResultsIn("Second Face detection Operation",
                                                reason: nil)
          completion(.failure(error))
        }
        return
      }
      
      // Processing results from operations
      /*
       1. Get aligned faces
       2. Pass them through ML model
       3. Return results
       */
      guard let firstAlignedFace = SFaceCompare.openCVwrapper.faceAlign(firstFaceOperationResults.image),
            let secondAlignedFace = SFaceCompare.openCVwrapper.faceAlign(secondFaceOperationResults.image) else {
        DispatchQueue.main.async {
          let error = SFaceError.wrongFaces(reason: "Faces can not be aligned. Try other images")
          completion(.failure(error))
        }
        return
      }
      do {
        let net = try Faces(configuration: .init())
        guard let firstPixelBuffer = firstAlignedFace.cvPixelBuffer,
              let secondPixelBuffer = secondAlignedFace.cvPixelBuffer else {
          DispatchQueue.main.async {
            let error = SFaceError
              .wrongFaces(reason: "Can not extract cvPixelBuffer to one of image. Try other images.")
            completion(.failure(error))
          }
          return
        }
        
        // neural networks answers getting
        let firstOutput = try net.prediction(data: firstPixelBuffer).output
        let secondOutput = try net.prediction(data: secondPixelBuffer).output
        // network outputs differece calculating
        let result = (0..<128)
          .reduce(0, { $0 + self.calculateDifference(firstOutput, secondOutput, at: $1) })
          .squareRoot()
        
        if result < matchingCoefficient {
          DispatchQueue.main.async {
            completion(.success(.init(detectionResults: [firstFaceOperationResults, secondFaceOperationResults],
                                      probability: result)))
          }
        } else {
          DispatchQueue.main.async {
            let error = SFaceError.wrongFaces(reason: "Faces are not the same. Matching coof is \(result)")
            completion(.failure(error))
          }
        }
      } catch {
        Logger.e(error.localizedDescription)
        DispatchQueue.main.async {
          completion(.failure(error))
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
  
  // MARK: - Private methods
  private func calculateDifference( _ first: MLMultiArray,
                                    _ second: MLMultiArray,
                                    at index: Int) -> Double {
    (Double(truncating: first[index]) - Double(truncating: second[index]))
      * (Double(truncating: first[index]) - Double(truncating: second[index]))
  }
}
