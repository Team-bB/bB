//
//  MyInfoVC.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit

class MyInfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addMyInfoHearder(vc: self)
    }
    

    func addMyInfoHearder(vc: UIViewController) {
        let myInfoHearder = MyInfoHeaderVC(nibName: "MyInfoHeaderVC", bundle: nil)
        myInfoHearder.view.frame = view.bounds
        vc.view.addSubview(myInfoHearder.view)
        vc.addChild(myInfoHearder)
    }

}
