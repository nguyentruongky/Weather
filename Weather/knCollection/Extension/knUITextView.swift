//
//  knUITextView.swift
//  kynguyenCodebase
//
//  Created by Ky Nguyen on 12/7/16.
//  Copyright © 2016 kynguyen. All rights reserved.
//

import UIKit

extension UITextView {
    
    func wrapText(aroundRect rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        textContainer.exclusionPaths = [path]
    }
}
