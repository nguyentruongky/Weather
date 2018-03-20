//
//  UIExtension.swift
//  kLibrary
//
//  Created by Ky Nguyen on 1/26/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    func changeTitleColor(_ color: UIColor = UIColor.blue, font: UIFont = UIFont.systemFont(ofSize: 14)) {
        let format = [
            NSAttributedStringKey.foregroundColor: color,
            NSAttributedStringKey.font: font]
        setTitleTextAttributes(format, for: .normal)
    }
}


extension UILabel{
    @discardableResult
    func formatParagraph(alignment: NSTextAlignment = NSTextAlignment.left, spacing: CGFloat = 7) -> [NSAttributedStringKey: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.maximumLineHeight = 40
        paragraphStyle.alignment = alignment

        let ats = [NSAttributedStringKey.paragraphStyle:paragraphStyle]
        attributedText = NSAttributedString(string: self.text!, attributes:ats)
        return ats
    }
    
    func formatText(boldStrings: [String] = [],
                    boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                    boldColor: UIColor = .black,
                    lineSpacing: CGFloat = 7,
                    alignment: NSTextAlignment = .left) {
        attributedText = String.format(strings: boldStrings,
                                       boldFont: boldFont,
                                       boldColor: boldColor,
                                       inString: text!,
                                       font: font,
                                       color: textColor,
                                       lineSpacing: lineSpacing,
                                       alignment: alignment)
    }
}


