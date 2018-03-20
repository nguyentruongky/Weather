//
//  GetWeatherWorker.swift
//  Weather
//
//  Created by Ky Nguyen Coinhako on 3/20/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import Foundation
//api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}

struct weaWeatherModel {
    var placeName: String?
    var weather: String?
    var weatherDesc: String?
    var temp: Double = 0
    var humidity: Double = 0
    var tempMin: Double = 0
    var tempMax: Double = 0
    
    init(rawData: AnyObject) {
        placeName = rawData.value(forKeyPath: "name") as? String
        if let weatherRaw = (rawData.value(forKeyPath: "weather") as? [AnyObject])?.first {
            weather = weatherRaw.value(forKeyPath: "main") as? String
            weatherDesc = weatherRaw.value(forKeyPath: "description") as? String
        }
        if let data = rawData.value(forKeyPath: "main.temp") as? Double {
            temp = data
        }
        
        if let data = rawData.value(forKeyPath: "main.humidity") as? Double {
            humidity = data
        }
        if let data = rawData.value(forKeyPath: "main.temp_min") as? Double {
            tempMin = data
        }
        if let data = rawData.value(forKeyPath: "main.temp_max") as? Double {
            tempMax = data
        }
    }
}

struct weaGetWeatherWorker : knWorker {
    
    private let api = "http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=%@"
    var lat: Double
    var long: Double
    
    var successResponse: ((_ data: weaWeatherModel) -> Void)? = nil
    var failResponse: ((_ error: knError) -> Void)? = nil
    
    func execute() {
        let formattedApi = String(format: api, lat, long, weaSetting.weatherKey)
        knServiceConnector.get(formattedApi, success: handleSuccess, fail: handleError)
    }
    
    func handleSuccess(returnData: AnyObject) {
        print(returnData)
        let weather = weaWeatherModel(rawData: returnData)
        successResponse?(weather)
    }
    
    func handleError(_ err: knError) {
        print(err)
    }
}



