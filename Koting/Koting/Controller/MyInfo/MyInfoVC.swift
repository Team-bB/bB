//
//  MyInfoVC.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//
import UIKit
import MessageUI
import NVActivityIndicatorView

fileprivate let reuseIdentifier = "cell"

class MyInfoVC: UIViewController, UINavigationControllerDelegate {
    fileprivate let infoList = MyInfo()
    let indicator = CustomIndicator()
    
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
        
//        indicator.startAnimating(superView: view)
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
        tableView.separatorInset.left = 30
        tableView.separatorInset.right = 30
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellName: String = infoList.list[indexPath.section]![indexPath.row]
        
        print("\(cellName) Cell Tapped")
        
        switch cellName {
        case "공지사항":
            self.asyncPresentView(identifier: "NoticeVC")
            break
        case "앱 정보":
            indicator.stopAnimating()
            break
        case "문의하기":
            showMessageView(email: "imjeongwoo@kakao.com", subject: "[Koting] 문의사항", body: "Content")
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
    
    func transImage(index: Int) -> String {
        switch index {
        case 1: return "dog"
        case 2: return "cat"
        case 3: return "rabbit"
        case 4: return "fox"
        case 5: return "bear"
        case 6: return "dino"
        default: return "nil"
        }
    }

}

extension MyInfoVC: MFMailComposeViewControllerDelegate {
    
    fileprivate func presentMailErrorAlert(email: String, subject: String, bodyText: String) {
        self.makeAlertBox(title: "실패", message: "이메일 설정을 확인후 시도해주세요.", text: "확인") { action in
            print("🔔 Ok button Tapped 🔔")
            self.dismiss(animated: true, completion:  nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            print("🔔 메일을 보냈습니다.🔔")
            self.makeAlertBox(title: "성공", message: "메일 전송했습니다.", text: "확인", handler: nil)
            
        case .failed:
            print("🔔 메일 전송실패 🔔")
            self.makeAlertBox(title: "전송실패", message: "메일 전송을 실패했습니다.", text: "확인", handler: nil)
            
        case .cancelled:
            print("🔔 닫기 🔔")
                
        case .saved:
            break
            
        @unknown default:
            fatalError()
            
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func showMessageView(email: String, subject: String, body: String) {
        
        if MFMailComposeViewController.canSendMail() {
            
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            
            mailComposeVC.setToRecipients([email])
            mailComposeVC.setSubject(subject)
            mailComposeVC.setMessageBody(body, isHTML: false)
            
            self.present(mailComposeVC, animated: true, completion: nil)
            
        } else {
            presentMailErrorAlert(email: email, subject: subject, bodyText: body)
        }
    }
    
}
