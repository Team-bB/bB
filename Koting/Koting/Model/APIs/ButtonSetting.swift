//
//  ButtonSetting.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import Foundation
import UIKit

func setEnable(button: UIButton!, enable: Bool? = true, backgroundColor: UIColor? = #colorLiteral(red: 1, green: 0.6597687742, blue: 0.3187801202, alpha: 1)) {
    button.isEnabled = enable!
    button.backgroundColor = backgroundColor
}

func setDisable(button: UIButton!, enable: Bool? = false, backgroundColor: UIColor? = .opaqueSeparator) {
    button.isEnabled = enable!
    button.backgroundColor = backgroundColor
}
