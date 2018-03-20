//
//  AlamofireConnector.swift
//  Weather
//
//  Created by Ky Nguyen Coinhako on 3/20/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import Foundation
import Alamofire

struct AlamofireConnector {
    
    func request(withApi api: URL?,
                 method: HTTPMethod,
                 params: [String: Any]? = nil,
                 header: [String: String]? = nil,
                 success: @escaping (_ result: AnyObject) -> Void,
                 fail: ((_ error: knError) -> Void)?) {
        
        guard let api = api else { return }
        let encoding: ParameterEncoding = method == .post || method == .put ? JSONEncoding.default : URLEncoding.queryString
        
        
        Alamofire.request(api, method: method, parameters: params, encoding: encoding, headers: header)
            .responseJSON { (response) in
                
                print("Alamofire:: Request:: \(String(describing: response.request?.url))")
                
                if self.isPhysicalFailure(response: response) {
                    print(response)
                    fail?(knError(code: .timeOut, message: response.result.error!.localizedDescription))
                    print("Alamofire:: Error:: \(response.result.error!.localizedDescription)")
                    return
                }
                
                if let error = self.isLogicalFailure(response: response.result.value as AnyObject) {
                    print("Alamofire:: Error: \(String(describing: error.message))")
                    fail?(error)
                    return
                }
                
                //            print("Alamofire:: Response: \(response.result.value!)")
                success(response.result.value! as AnyObject)
        }
    }
    
    private func isPhysicalFailure(response: DataResponse<Any>) -> Bool {
        return response.result.error != nil
    }
    
    private func isLogicalFailure(response: AnyObject) -> knError? {
        
        let error = JSONParser.getBool(forKey: "error", inObject: response)
        if error == true {
            let message = JSONParser.getString(forKey: "msg", inObject: response)
            return knError(code: .notSure, message: message)
        }
        return nil
    }
    
    
    
    
}

