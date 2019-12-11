//
//  AppDelegate.swift
//  Prynote2
//
//  Created by tongyi on 12/10/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureRootViewController()
        Storage.load()
        return true
    }
    
    func configureRootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = RootViewController()
    }
}

