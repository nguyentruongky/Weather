//
//  knOptional.swift
//  Ogenii
//
//  Created by Ky Nguyen on 6/15/17.
//  Copyright © 2017 Ogenii. All rights reserved.
//

import Foundation

extension Optional {
    func or<T>(_ defaultValue: T) -> T {
        switch(self) {
        case .none:
            return defaultValue
        case .some(let value):
            return value as! T
        }
    }
}
