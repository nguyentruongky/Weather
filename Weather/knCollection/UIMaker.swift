//
//  UIMaker.swift
//  Weather
//
//  Created by Ky Nguyen Coinhako on 3/20/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

struct knUIMaker {
    
    
    static func makeButton(title: String, font: UIFont, titleColor: UIColor? = .black, background: UIColor? = nil) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = font
        button.backgroundColor = background
        return button
    }
    
    static func makeButton(image: UIImage? = nil) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }
    
    static func makeView(background: UIColor = .clear) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = background
        return view
    }
    
    static func makeLabel(font: UIFont? = nil, color: UIColor? = .black, text: String? = nil, numberOfLines: Int = 1, alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = color
        label.text = text
        label.textAlignment = alignment
        label.numberOfLines = numberOfLines
        return label
    }
    
    static func makeTextField(font: UIFont?, color: UIColor? = .black,
                              placeholder: String? = nil, text: String? = nil, alignment: NSTextAlignment = .left) -> UITextField {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.text = text
        tf.font = font
        tf.textColor = color
        tf.autocorrectionType = .no
        tf.placeholder = placeholder
        tf.textAlignment = alignment
        tf.inputAccessoryView = knUIMaker.makeKeyboardDoneView()
        return tf
    }
    
    static func makeImageView(image: UIImage? = nil, contentMode: UIViewContentMode = .scaleAspectFill) -> UIImageView {
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = contentMode
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }
    
    static func makeSeparator() -> UIView {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.height(1)
        separator.backgroundColor = UIColor.color(value: 235)
        return separator
    }
    
    static func makeLine(color: UIColor = UIColor.color(value: 235)) -> UIView {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.height(1)
        separator.backgroundColor = color
        return separator
    }
    
    static func makeKeyboardDoneView(title: String = "Done", doneAction: Selector? = nil) -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 35))
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.color(value: 3), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        if let doneAction = doneAction {
            button.addTarget(self, action: doneAction, for: .touchUpInside)
        }
        else {
            button.addTarget(appDelegate, action: #selector(appDelegate.hideKeyboard), for: .touchUpInside)
        }
        
        view.addSubview(button)
        button.right(toView: view, space: -padding)
        button.centerY(toView: view)
        
        view.backgroundColor = UIColor.color(value: 235)
        
        return view
    }
    
    
}
