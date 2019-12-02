//
//  AppDelegate.swift
//  JoystickTank
//
//  Created by Alex Nagy on 05/07/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    window = UIWindow()
    window?.makeKeyAndVisible()
    
    let viewController = ManualViewController()
    window?.rootViewController = viewController
    
    return true
  }

  


}


