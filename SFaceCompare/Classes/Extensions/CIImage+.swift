//
//  CIImage+.swift
//  SFaceCompare
//
//  Created by Soft Project on 6/5/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

extension CIImage {
  
  var uiImage: UIImage? {
    let context = CIContext.init(options: nil)
    guard let cgImage = context.createCGImage(self, from: self.extent) else { return nil }
    return UIImage(cgImage: cgImage)
  }
}
