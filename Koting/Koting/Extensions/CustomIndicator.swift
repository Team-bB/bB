//
//  CustomIndicator.swift
//  Koting
//
//  Created by 임정우 on 2021/05/10.
//

import UIKit
import NVActivityIndicatorView

class CustomIndicator: UIView {
    
    var isAnimating: Bool = false
    
   override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6972082277)
        
        self.addSubview(NVActivityIndicatorView(
            frame: CGRect(
                origin: CGPoint(x: self.center.x - 50, y: self.center.y - 50),
                size: CGSize(width: 100, height: 100)
            ),
            type: .ballBeat,
            color: #colorLiteral(red: 0.9975556731, green: 0.493971467, blue: 0.2088408768, alpha: 1),
            padding: 0
        ))

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating(superView: UIView) {
        
        if isAnimating == true {
            return
        }
        
        self.isAnimating = true
        self.frame = superView.bounds
        
        let indicator = self.subviews.first as! NVActivityIndicatorView
        
        indicator.frame = CGRect(
            origin: CGPoint(x: self.center.x - 35, y: self.center.y - 35), size: CGSize(width: 70, height: 70))
            
        superView.addSubview(self)
        indicator.startAnimating()
    }
    
    func stopAnimating() {
        
        if isAnimating == false {
            return
        }
        
        self.isAnimating = false
        let indicator = self.subviews.first as! NVActivityIndicatorView
        
        self.removeFromSuperview()
        indicator.stopAnimating()
    }
}
