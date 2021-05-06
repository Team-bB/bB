//
//  StrechyHeader.swift
//  Koting
//
//  Created by 임정우 on 2021/05/07.
//

import UIKit

class StrechyHeader: UIView {
    private let headerView: UIView! = {
        let headerVC = MyInfoHeaderVC(nibName: "MyInfoHeaderVC", bundle: nil)
        return headerVC.view        
    }()
    
    private var headerViewHeight = NSLayoutConstraint()
    private var headerViewBottom = NSLayoutConstraint()
    private var subHeaderViewHeight = NSLayoutConstraint()
    
}
