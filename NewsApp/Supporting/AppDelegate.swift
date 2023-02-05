//
//  AppDelegate.swift
//  NewsApp
//
//  Created by Izyumets Aleksandr on 04.02.2023.
//

import UIKit

// DI
let resolver = DependencyResolver()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let viewController = resolver.newsAssembly.assemble()
        
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        return true
    }

}

