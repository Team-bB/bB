//
//  GradientView.swift
//  Koting
//
//  Created by 임정우 on 2021/05/05.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var topColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor
    @IBInspectable var bottomColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1).cgColor
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 150)
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [topColor, bottomColor]
        layer.insertSublayer(gradient, at: 0)
    }
}
