//
//  CustomTextField.swift
//  Homepwner
//
//  Created by Danny Espina on 10/16/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        layer.borderColor = UIColor.cyan.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        layer.borderWidth = 0.0
        return true
    }
}
