//
//  CustomIndicator.swift
//  Koting
//
//  Created by 임정우 on 2021/05/10.
//

import UIKit
import NVActivityIndicatorView

class CustomIndicator: UIView {

    override init(frame: CGRect) {
        super .init(frame: frame)
        
        self.backgroundColor = UIColor(cgColor: CGColor(red: 255, green: 255, blue: 255, alpha: 0.7))
        
        self.addSubview(NVActivityIndicatorView(
            frame: CGRect(
                origin: CGPoint(x: self.center.x - 50, y: self.center.y - 50),
                size: CGSize(width: 100, height: 100)
            ),
            type: .ballBeat,
            color: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1),
            padding: 0
        ))

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating(superView: UIView) {
        
        self.frame = superView.bounds
        
        let indicator = self.subviews.first as! NVActivityIndicatorView
        
        indicator.frame = CGRect(
            origin: CGPoint(x: self.center.x - 35, y: self.center.y - 35), size: CGSize(width: 70, height: 70))
            
        superView.addSubview(self)
        indicator.startAnimating()
    }
    
    func stopAnimating() {
        
        let indicator = self.subviews.first as! NVActivityIndicatorView
        
        self.removeFromSuperview()
        indicator.stopAnimating()
    }
}
