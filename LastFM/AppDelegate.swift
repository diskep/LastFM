//
//  AppDelegate.swift
//  LastFM
//
//  Created by Timur Mustafaev on 29.03.2021.
//

import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    let dependencyManager = DependencyManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        true
    }
}
