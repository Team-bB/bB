//
//  LoadingHUD.swift
//  Koting
//
//  Created by 임정우 on 2021/04/27.
//

import Foundation
import NVActivityIndicatorView

class LoadingHUD {
    
    private static let shared = LoadingHUD()
    
    private init() {}
    
    var activityIndicator : NVActivityIndicatorView!
    
    class func show() {
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 45, height: 45)
    }
    
}
