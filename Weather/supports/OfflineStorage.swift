//
//  OfflineStorage.swift
//  Weather
//
//  Created by Ky Nguyen Coinhako on 3/21/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

class weaOfflineStorage {
    
    static func save(weather: weaWeatherModel) {
        var index = 0
        while UserDefaults.standard.value(forKeyPath: String(index)) != nil {
            index += 1
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: weather)
        UserDefaults.standard.setValue(data, forKey: String(index))
    }
    
    static func getList() -> [weaWeatherModel] {
        var weathers = [weaWeatherModel]()
        var index = 0
        while let data = UserDefaults.standard.value(forKeyPath: String(index)) as? Data {
            if let weather = NSKeyedUnarchiver.unarchiveObject(with: data) as? weaWeatherModel {
                if weathers.contains(where: { $0.placeName == weather.placeName }) == false {
                    weathers.append(weather)
                }
            }
            index += 1
        }
        
        
        
        return weathers
    }
    
}
