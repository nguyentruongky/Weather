//
//  AppDelegate.swift
//  Weather
//
//  Created by Ky Nguyen Coinhako on 3/20/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupApp()
        setupGoogleMap()
        return true
    }
    
    func setupApp() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = weaSetting.firstController
        window!.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
    }
    
    func setupGoogleMap() {
        GMSServices.provideAPIKey(weaSetting.mapKey)
        GMSPlacesClient.provideAPIKey(weaSetting.placeKey)
    }

    @objc func hideKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }

}

