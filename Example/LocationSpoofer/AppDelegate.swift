//
//  AppDelegate.swift
//  LocationSpoofer
//
//  Copyright © 2019 Buglife, Inc. All rights reserved.
//

import UIKit
import LocationSpoofer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let vc = ViewController()
        let nav = UINavigationController(rootViewController: vc)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}

