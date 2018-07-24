//
//  SFaceError.swift
//  SFaceCompare
//
//  Created by Bohdan Mihiliev on 6/5/18.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//
/// Describes Errors that can happen in the app
public enum SFaceError: Error {
  // MARK: - Properties
  case emptyResultsIn(String, reason: String?)
  case canNotCreate(String, reason: String?)
  case wrongFaces(reason: String)
  
  // MARK: - Public methods
  public var localizedDescription: String {
    switch self {
    case .emptyResultsIn(let destination, reason: let possibleReason):
      return "Empty results in \(destination), with: \(possibleReason ?? " ")"
    case .canNotCreate(let whoom, reason: let possibleReason):
      return "Can not craete \(whoom), with: \(possibleReason ?? " ")"
    case .wrongFaces:
      return "Faces you have passed are not the same"
    }
  }
}
