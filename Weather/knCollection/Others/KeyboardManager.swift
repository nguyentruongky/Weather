//
//  KeyboardManager.swift
//  WorkshopFixir
//
//  Created by Ky Nguyen on 2/11/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

protocol KeyboardManagerDelegate {
    
    func keyboardWillHide()
    
    func keyboardWillShow(_ notification: Notification)
}


final class KeyboardManager : UIView {
    
    var delegate : KeyboardManagerDelegate?
    
    init(delegate: KeyboardManagerDelegate) {
        super.init(frame: .zero)
        
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registerKeyboardNotifications() {
        let notificationCenter = Foundation.NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unregisterKeyboardNotification() {
        let notificationCenter = Foundation.NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        delegate?.keyboardWillShow(notification)
    }
    
    @objc func keyboardWillHide() {
        
        delegate?.keyboardWillHide()
    }
    
    
}

