//
//  ButtonSetting.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit

extension UIButton {
    
    func setEnable(enable: Bool? = true, backgroundColor: UIColor? = #colorLiteral(red: 1, green: 0.6597687742, blue: 0.3187801202, alpha: 1)) {
        self.isEnabled = enable!
        self.backgroundColor = backgroundColor
    }

    func setDisable(enable: Bool? = false, backgroundColor: UIColor? = .opaqueSeparator) {
        self.isEnabled = enable!
        self.backgroundColor = backgroundColor
    }
    
}
