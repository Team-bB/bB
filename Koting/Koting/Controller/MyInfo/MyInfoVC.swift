//
//  MyInfoVC.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit

class MyInfoVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addMyInfoHearder(vc: self)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func addMyInfoHearder(vc: UIViewController) {
        let myInfoHearder = MyInfoHeaderVC(nibName: "MyInfoHeaderVC", bundle: nil)
        tableView.tableHeaderView = myInfoHearder.view
//        myInfoHearder.view.frame = view.bounds
//        vc.view.addSubview(myInfoHearder.view)
//        vc.addChild(myInfoHearder)
//        view.clipsToBounds = true // 이걸해야 버튼이 눌림..
    }

}
