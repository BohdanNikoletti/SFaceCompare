//
//  AppDelegate.swift
//  SFaceCompare
//
//  Created by Bohdan Mihiliev on 06/06/2018.
//  Copyright (c) 2018 Bohdan Mihiliev. All rights reserved.
//

import UIKit
import SFaceCompare

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
  
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      SFaceCompare.opncvwrp.loadData()
      return true
    }

}

