//
//  GradientView.swift
//  Koting
//
//  Created by 임정우 on 2021/05/05.
//

import UIKit


class GradientView: UIView {
    
    var topColor = #colorLiteral(red: 0.9960784314, green: 0.4941176471, blue: 0.2117647059, alpha: 1).cgColor
    var bottomColor = #colorLiteral(red: 0.9411764706, green: 0.5647058824, blue: 0.3098039216, alpha: 1).cgColor
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 175)
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [topColor, bottomColor]
        layer.insertSublayer(gradient, at: 0)
    }
}
