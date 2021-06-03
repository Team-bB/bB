//
//  UIButton++.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit

extension UIButton {
    
    func setEnable(enable: Bool? = true, backgroundColor: UIColor? = #colorLiteral(red: 0.9960784314, green: 0.4941176471, blue: 0.2078431373, alpha: 1)) {
        isEnabled = enable!
        setTitleColor(.white, for: .normal)
        
        layer.cornerRadius = 8
        layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 4
        
        self.backgroundColor = backgroundColor
    }

    func setDisable(enable: Bool? = false, `backgroundColor`: UIColor? = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)) {
        isEnabled = enable!
        setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        
        layer.cornerRadius = 8
        layer.shadowColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 4
        
        self.backgroundColor = `backgroundColor`
    }
}
