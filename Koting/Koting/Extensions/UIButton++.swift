//
//  UIButton++.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit

extension UIButton {
    
    func setEnable(enable: Bool? = true, backgroundColor: UIColor? = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)) {
        self.isEnabled = enable!
        self.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.backgroundColor = backgroundColor
    }

    func setDisable(enable: Bool? = false, `backgroundColor`: UIColor? = .opaqueSeparator) {
        self.isEnabled = enable!
        self.backgroundColor = `backgroundColor`
    }
    
    func setDefault(value: CGFloat? = 8, bool: Bool? = true) {
        self.layer.cornerRadius = value!
        self.layer.masksToBounds = bool!
    }
}

class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setRadiusAndShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setRadiusAndShadow()
    }
    
    func setRadiusAndShadow() {
        setDefault()
        setEnable()
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
        layer.masksToBounds = true
        
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowColor =  #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    }
}

