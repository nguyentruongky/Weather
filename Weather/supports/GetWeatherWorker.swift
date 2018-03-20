//
//  GetWeatherWorker.swift
//  Weather
//
//  Created by Ky Nguyen Coinhako on 3/20/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import Foundation
class weaWeatherModel: NSObject, NSCoding {
    var placeName: String?
    var country: String?
    var weather: String?
    var weatherDesc: String?
    var temp: String = ""
    var humidity: String = ""
    var tempMin: String = ""
    var tempMax: String = ""
    
    required init(coder aDecoder: NSCoder) {
        placeName = aDecoder.decodeObject(forKey: "placeName") as? String
        country = aDecoder.decodeObject(forKey: "country") as? String
        weather = aDecoder.decodeObject(forKey: "weather") as? String
        weatherDesc = aDecoder.decodeObject(forKey: "weatherDesc") as? String
        temp = aDecoder.decodeObject(forKey: "temp") as? String ?? ""
        humidity = aDecoder.decodeObject(forKey: "humidity") as? String ?? ""
        tempMin = aDecoder.decodeObject(forKey: "tempMin") as? String ?? ""
        tempMax = aDecoder.decodeObject(forKey: "tempMax") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(placeName, forKey: "placeName")
        aCoder.encode(country, forKey: "country")
        aCoder.encode(weather, forKey: "weather")
        aCoder.encode(weatherDesc, forKey: "weatherDesc")
        aCoder.encode(temp, forKey: "temp")
        aCoder.encode(humidity, forKey: "humidity")
        aCoder.encode(tempMin, forKey: "tempMin")
        aCoder.encode(tempMax, forKey: "tempMax")
    }
    
    init(rawData: AnyObject) {
        placeName = rawData.value(forKeyPath: "name") as? String
        country = rawData.value(forKeyPath: "sys.country") as? String
        if let weatherRaw = (rawData.value(forKeyPath: "weather") as? [AnyObject])?.first {
            weather = weatherRaw.value(forKeyPath: "main") as? String
            weatherDesc = weatherRaw.value(forKeyPath: "description") as? String
        }
        if let data = rawData.value(forKeyPath: "main.temp") as? Double {
            temp = String(data) + "°F"
        }
        
        if let data = rawData.value(forKeyPath: "main.humidity") as? Double {
            humidity = String(data)
        }
        if let data = rawData.value(forKeyPath: "main.temp_min") as? Double {
            tempMin = String(data) + "°F"
        }
        if let data = rawData.value(forKeyPath: "main.temp_max") as? Double {
            tempMax = String(data) + "°F"
        }
    }
}

struct weaGetWeatherWorker : knWorker {
    
    private let api = "http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=%@&units=imperial"
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



