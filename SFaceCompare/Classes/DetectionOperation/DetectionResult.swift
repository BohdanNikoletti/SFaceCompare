//
//  File.swift
//  SFaceCompare
//
//  Created by Bohdan Mihiliev on 6/5/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

/**
 This struct stends for storing detection operations results.
 */
public struct DetectionResult {
  
  // MARK: - Properties
  
  /// The detected object image.
  public let image: UIImage
  /// The detected object rectangle.
  public let rect: CGRect
  /// Additionnal information provided by operation.
  public let payLoad: [String: Any]?
  
  // MARK: - Initializers
  init(image: UIImage, rect: CGRect, payLoad: [String: Any]? = nil) {
    self.image = image
    self.rect = rect
    self.payLoad = payLoad
  }
}
