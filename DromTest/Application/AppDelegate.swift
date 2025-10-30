//
//  AppDelegate.swift
//  DromTest
//
//  Created by v.sklyarov on 29.10.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        window.rootViewController = UINavigationController()
        window.makeKeyAndVisible()
        
        self.window = window
        let viewController = DisplayPicturesCollectionAssembly.build()
        viewController.modalPresentationStyle = .fullScreen
        window.rootViewController?.present(viewController, animated: false)
        return true
    }
    
}

