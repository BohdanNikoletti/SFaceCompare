//
//  CIImage+.swift
//  SFaceCompare
//
//  Created by Bohdan Mihiliev on 6/5/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

extension CIImage {
  var uiImage: UIImage? {
    CIContext(options: nil)
      .createCGImage(self, from: self.extent)
      .map {
        UIImage(cgImage: $0)
      }
  }
}
