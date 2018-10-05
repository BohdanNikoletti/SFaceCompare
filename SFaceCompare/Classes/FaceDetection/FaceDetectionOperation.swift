//
//  FaceDetection.swift
//  SFaceCompare
//
//  Created by Bohdan Mihiliev on 6/4/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//
import Vision

final class FaceDetectionOperation: Operation {
    
    // MARK: - Properties
    let cGAffineTransform: CGAffineTransform
    private let inputImage: CIImage
    private let imageToProcess: UIImage
    private let vNImageRequestHandler: VNImageRequestHandler
    private (set) var objectsCountToDetect = 0
    private (set) var operationResult: [DetectionResult]?
    
    // MARK: - Initializers
    init?(input image: CIImage, objectsCountToDetect: Int = 0, orientation: CGImagePropertyOrientation = .up) {
        self.inputImage = image
        guard let inputUIImage = image.uiImage else { return nil }
        self.imageToProcess = inputUIImage
        self.cGAffineTransform = CGAffineTransform.identity
            .scaledBy(x: inputUIImage.size.width, y: -inputUIImage.size.height)
            .translatedBy(x: 0, y: -1)
        self.objectsCountToDetect = objectsCountToDetect
        self.vNImageRequestHandler = VNImageRequestHandler(ciImage: image, orientation: orientation)
    }
    
    convenience init?(input image: CGImage, objectsCountToDetect: Int = 0, orientation: CGImagePropertyOrientation = .up) {
        let image = CIImage(cgImage: image)
        self.init(input: image, objectsCountToDetect: objectsCountToDetect, orientation: orientation)
    }
    
    convenience init?(input image: UIImage, objectsCountToDetect: Int = 0, orientation: CGImagePropertyOrientation = .up) {
        guard let image = CIImage(image: image) ?? image.ciImage else { return nil }
        self.init(input: image, objectsCountToDetect: objectsCountToDetect, orientation: orientation)
    }
    
    // MARK: - Lifecycle events
    override func main() {
        super.main()
        if isCancelled { return }

        let faceDetectionRequest = VNDetectFaceRectanglesRequest { [weak self] request, error in
            guard let self = self else { return }
            if let error = error {
                Logger.e("\(error.localizedDescription)")
                return
            }
            
            guard let results = request.results as? [VNFaceObservation] else {
                fatalError("Unexpected result type from VNDetectFaceRectanglesRequest")
            }
            
            // Need check results only if objectsCountToDetect isn't default
            if self.objectsCountToDetect != 0 {
                guard results.count == self.objectsCountToDetect else {
                    Logger.e("Wrong Face Results count: Founded - \(results.count) | Required - \(self.objectsCountToDetect)")
                    return
                }
            }
            
            if self.isCancelled { return }
            
            self.operationResult = results
                .lazy
                .map { $0.boundingBox.applying(self.cGAffineTransform) }
                .compactMap {  rect -> DetectionResult? in
                    guard let detectedFaceCIImage = self.imageToProcess
                        .cgImage?
                        .cropping(to: rect) else { return nil }
                    return DetectionResult(image: UIImage(cgImage: detectedFaceCIImage),
                                           rect: rect)
            }
        }
        do {
            try vNImageRequestHandler.perform([faceDetectionRequest])
        } catch {
            Logger.e("Wrong Face Results count: \(error.localizedDescription)")
        }
    }
}


