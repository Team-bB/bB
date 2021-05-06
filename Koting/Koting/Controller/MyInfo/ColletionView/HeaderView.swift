//
//  HeaderView.swift
//  Koting
//
//  Created by 임정우 on 2021/05/06.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    @IBOutlet weak var header: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        addMyInfoHearder(headerView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addMyInfoHearder(headerView: UICollectionReusableView) {
        let myInfo = MyInfoHeaderVC(nibName: "MyInfoHeaderVC", bundle: nil)
        myInfo.view.frame = headerView.bounds
        
        headerView.addSubview(myInfo.view)
        myInfo.view.fillSuperview()
//        myInfo.view
//        myInfo.view.clipsToBounds = true
//        headerView.clipsToBounds = true // 이걸해야 버튼이 눌림..
    }
}
