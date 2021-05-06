//
//  MyInfoVC.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit

fileprivate let reuseIdentifier = "cell"

class MyInfoVC: UIViewController {
    fileprivate let list = MyInfo().list
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        return tableView
    }()
    
    private var headerViewHeight = NSLayoutConstraint()
    private var headerViewBottom = NSLayoutConstraint()
    private var tableHeaderViewHeight = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        addMyInfoHearder(vc: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
                tableView.contentInsetAdjustmentBehavior = .never
    }
    
   
    func addMyInfoHearder(vc: UIViewController) {
        let myInfoHearder = MyInfoHeaderVC(nibName: "MyInfoHeaderVC", bundle: nil)
        if let header = myInfoHearder.view {

            tableView.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
            tableView.tableHeaderView = header
            header.fillSuperview()
//            tableView.clipsToBounds = true
            tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200)


        }
       
    }
    
//    func setViewConstraints() {
//        NSLayoutConstraint.activate([view.width])
//    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        )
//    }

}

extension MyInfoVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
}
