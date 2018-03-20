//
//  Setting.swift
//  Weather
//
//  Created by Ky Nguyen Coinhako on 3/20/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

class weaSetting {
    static var baseUrl = ""
    
    static let weatherKey = "d13f51d3e63301f8cef3a2c30ba13b36"
    static let mapKey = "AIzaSyBncA4YYHzDDLV0s0GHbd9jbMlKpCuv_E0"
    static let placeKey = "AIzaSyDw_StpsxMdUCrZ40FuihBh22Gw9qh1IoQ"
    
    static var firstController: UIViewController {
        return UINavigationController(rootViewController: weaMapController())
    }
}


let padding: CGFloat = 16
