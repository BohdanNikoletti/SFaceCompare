//
//  Date+.swift
//  SFaceCompare
//
//  Created by Bohdan Mihiliev on 03.06.2018.
//  Copyright © 2018 Bohdan Mihiliev. All rights reserved.
//

extension Date {
  var iso8601: String {  Formatter.iso8601.string(from: self) }
}
