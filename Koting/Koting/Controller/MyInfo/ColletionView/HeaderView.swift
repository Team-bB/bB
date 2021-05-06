//
//  HeaderView.swift
//  Koting
//
//  Created by 임정우 on 2021/05/06.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    @IBOutlet weak var header: UIView!
    var animator: UIViewPropertyAnimator!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addMyInfoHearder(headerView: self)
//        setupVisualEffectBlur()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addMyInfoHearder(headerView: UICollectionReusableView) {
        let myInfo = MyInfoHeaderVC(nibName: "MyInfoHeaderVC", bundle: nil)
        myInfo.view.frame = headerView.bounds
        
        headerView.addSubview(myInfo.view)
        myInfo.view.fillSuperview()
        
    }
    
    fileprivate func setupVisualEffectBlur() {
        animator = UIViewPropertyAnimator(duration: 3.0, curve: .easeInOut, animations: {
            [weak self] in
            
            let blurEffect = UIBlurEffect(style: .regular)
            let visualEffectView = UIVisualEffectView(effect: blurEffect)
            
            self?.addSubview(visualEffectView)
            visualEffectView.fillSuperview()
        })
    }
}
