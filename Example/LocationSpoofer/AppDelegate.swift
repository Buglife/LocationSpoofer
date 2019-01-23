//
//  AppDelegate.swift
//  LocationSpoofer
//
//  Copyright © 2019 Buglife, Inc. All rights reserved.
//

import UIKit
import LocationSpoofer
import Buglife

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
        
        configureBuglife()
        
        return true
    }
    
    private func configureBuglife() {
        Buglife.shared().start(withAPIKey: "QRhrGr7g7W5EvGRTK9ctmgtt")
        
        // Customize Buglife's appearance
        Buglife.shared().appearance.tintColor = .white
        Buglife.shared().appearance.barTintColor = .ls_appTintColor
        Buglife.shared().appearance.statusBarStyle = .lightContent
        
        // Show both the email field and the summary field
        Buglife.shared().inputFields = [LIFETextInputField.userEmail(), LIFETextInputField.summary()];
    }
}

