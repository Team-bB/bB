//
//  CustomUITextField.swift
//  Koting
//
//  Created by 임정우 on 2021/05/26.
//

import UIKit  //Don't forget this

class CustomUITextField: UITextField {
   override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
   }
}
