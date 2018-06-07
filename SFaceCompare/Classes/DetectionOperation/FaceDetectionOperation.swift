//
//  FaceDetection.swift
//  SFaceCompare
//
//  Created by Bohdan Mihiliev on 6/4/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//
import Vision

final class FaceDetectionOperation: BaseDetectionProcessOperation<VNDetectFaceRectanglesRequest> {
  
  // MARK: - Lifecycle events
  override func main() {
    super.main()
    if isCancelled { return }
    do {
      try vNImageRequestHandler.perform([recognitionRequest])
    } catch {
      Logger.e("Wrong Face Results count: \(error.localizedDescription)")
    }
  }
  
  // MARK: - BaseDetectionProcessOperation methods
  override func recognitionHandler(request: VNRequest, error: Error?) {
    if let error = error {
      Logger.e("\(error.localizedDescription)")
      return
    }
    
    guard let results = request.results as? [VNFaceObservation] else {
      fatalError("Unexpected result type from VNDetectFaceRectanglesRequest")
    }
    
    // Need check results only if objectsCountToDetect isn't default
    if objectsCountToDetect != 0 {
      guard results.count == objectsCountToDetect else {
        Logger.e("Wrong Face Results count: Founded - \(results.count) | Required - \(objectsCountToDetect)")
        return
      }
    }
    
    if isCancelled { return }
    
    operationResult = results
      .lazy
      .map { [unowned self] in $0.boundingBox.applying(self.cGAffineTransform) }
      .compactMap {  rect -> DetectionResult? in
        guard let detectedFaceCIImage = imageToProcess
          .cgImage?
          .cropping(to: rect) else { return nil }
        return DetectionResult(image: UIImage(cgImage: detectedFaceCIImage),
                               rect: rect)
    }
  }
}


