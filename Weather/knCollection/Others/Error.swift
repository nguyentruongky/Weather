//
//  Error.swift
//  Fixir
//
//  Created by Ky Nguyen on 4/6/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit


enum knErrorCode : String {
    case loginFail
    case invalidEmail
    case invalidPassword
    case notFound
    case timeOut
    case noInternet
    case serverError
    case empty
    case emailExist
    case emptyPassword
    case weakPassword
    case notSure
    case facebookCancel
    case cantGetUploadedUrl
    case uploadFail
    
    case sendFail
}

struct knError {
    var code: knErrorCode?
    var message: String?
    var statusCode: Int?
    var data: AnyObject?
    
    init(code: knErrorCode?, message: String?) {
        self.code = code
        self.message = message
    }
    
    init(code: Int?, data: AnyObject?) {
        statusCode = code
        self.data = data
    }
    
    init() { }
}
