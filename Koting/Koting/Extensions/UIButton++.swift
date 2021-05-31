//
//  UIButton++.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit

extension UIButton {
    
    func setEnable(enable: Bool? = true, backgroundColor: UIColor? = #colorLiteral(red: 0.9975556731, green: 0.493971467, blue: 0.2088408768, alpha: 1)) {
        isEnabled = enable!
        setTitleColor(.white, for: .normal)
        
        layer.cornerRadius = 12
        layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 4
        
        self.backgroundColor = backgroundColor
    }

    func setDisable(enable: Bool? = false, `backgroundColor`: UIColor? = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)) {
        isEnabled = enable!
        setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        
        layer.cornerRadius = 12
        layer.shadowColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 4
        
        self.backgroundColor = `backgroundColor`
    }
    
//    func setDefault(value: CGFloat? = 0.3, bool: Bool? = true) {
//        //self.layer.cornerRadius = value!
//        layer.borderWidth = value!
//        layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
//    }
}

//class CustomButton: UIButton {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setRadiusAndShadow()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setRadiusAndShadow()
//    }
    
//    func setRadiusAndShadow() {
////        setDefault()
//        setEnable()
////        layer.cornerRadius = frame.height / 2
//        clipsToBounds = true
//        layer.masksToBounds = true
//
////        let gradient = CAGradientLayer()
////        gradient.frame = bounds
////        gradient.startPoint = CGPoint(x: 0, y: 0)
////        gradient.endPoint = CGPoint(x: 1, y: 1)
////        gradient.colors = [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor, #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1).cgColor]
////        layer.addSublayer(gradient)
//    }
//}
