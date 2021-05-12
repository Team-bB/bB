//
//  GradientView.swift
//  Koting
//
//  Created by 임정우 on 2021/05/05.
//

import UIKit


class GradientView: UIView {
    
    var topColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).cgColor
    var bottomColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).cgColor
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 200)
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [topColor, bottomColor]
        layer.insertSublayer(gradient, at: 0)
    }
}
