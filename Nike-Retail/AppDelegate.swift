//
//  AppDelegate.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 4/4/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit
import Firebase
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        configureAppearance()
        configureStripe()
        
        return true
    }

    func configureAppearance()
    {
        UITabBar.appearance().tintColor = UIColor.black
        UITabBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().isTranslucent = false
    }
    
    func configureStripe()
    {
        STPPaymentConfiguration.shared().publishableKey = "sk_test_AXQxjWloEA5fWCDDRjeEbN8I00fAxHRm0J"
        
    }
}

