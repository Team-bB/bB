//
//  MyInfoVC.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//
import SwiftUI

struct MyInfoVCRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MyInfoVC

    func makeUIViewController(context: Context) -> MyInfoVC {
        return MyInfoVC()
    }

    func updateUIViewController(_ uiViewController: MyInfoVC, context: Context) {
    }
}

@available(iOS 13.0.0, *)
struct MyInfoPreview: PreviewProvider {
    static var previews: some View {
        MyInfoVCRepresentable()
    }
}

import UIKit

fileprivate let reuseIdentifier = "cell"

class MyInfoVC: UIViewController {
    fileprivate let infoList = MyInfo()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        return tableView
    }()
    
    private var headerViewHeight = NSLayoutConstraint()
    private var headerViewBottom = NSLayoutConstraint()
    private var tableHeaderViewHeight = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        if let data = UserDefaults.standard.value(forKey:"myInfo") as? Data {
            let infoData = try! PropertyListDecoder().decode(Owner.self, from: data)
            
            print(infoData.age!)
            print(infoData.sex!)
            print(infoData.height!)
            print(infoData.college!)
            print(infoData.major!)
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.frame = view.bounds
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.contentInsetAdjustmentBehavior = .never
        
        addMyInfoHearder(vc: self)
    }
    
   
    func addMyInfoHearder(vc: UIViewController) {
        let myInfoHearder = MyInfoHeaderVC(nibName: "MyInfoHeaderVC", bundle: nil)
        if let header = myInfoHearder.view {
            tableView.tableHeaderView = header
            tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 290)
        }
    }
}

extension MyInfoVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return infoList.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return infoList.sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return infoList
            .list[section]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = infoList.list[indexPath.section]?[indexPath.row]
        cell.selectionStyle = .none // 클릭효과 X
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsectY = tableView.contentOffset.y
        
        // 위로 올릴때
        if contentOffsectY > 0 {
            return
        }
        
        let width = tableView.frame.width
        
//                let height = attributes.frame.height - contentOffsectY
        // For Header
        tableView.frame = CGRect(x: 0, y: contentOffsectY, width: width, height: tableView.frame.height)
        print(tableView.contentOffset.y)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellName: String = infoList.list[indexPath.section]![indexPath.row]
        
        print("\(cellName) Cell Tapped")
        print("section : \(indexPath.section) row : \(indexPath.row)")
        
        switch cellName {
        case "공지사항":
            break
        case "앱 정보":
            break
        case "문의하기":
            break
        case "동물상 재측정":
            break
        case "로그아웃":
            logOut()
            break
        case "회원탈퇴":
            break
        default:
            break
        }
    }
    
    fileprivate func logOut() {
        guard let _ = UserDefaults.standard.string(forKey: "accountId")
        else {
            print("⚠️ Unknown Error ⚠️")
            return }
        UserDefaults.standard.removeObject(forKey: "accountId")
 
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GettingStarted") as! GettingStartedVC
        self.dismiss(animated: true, completion: nil)
        self.present(vc, animated: true, completion: nil)
        
    
        print(" ✅ LogOut Success ✅")
    }
}
