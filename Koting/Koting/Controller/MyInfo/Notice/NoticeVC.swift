//
//  NoticeVC.swift
//  Koting
//
//  Created by 임정우 on 2021/05/11.
//

import UIKit

fileprivate let reuseIdentifier = "cell"

class NoticeVC: UIViewController {
    
    let cellHeight = CGFloat(80)
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = cellHeight
        tableView.separatorInset.left = 20
        tableView.separatorInset.right = 20
//        tableView.reloadData()
    }
}

extension NoticeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoticeCell
        
        cell.date.textColor = .lightGray
        switch indexPath.row {
        case 0:
            cell.title.text = "[공지] 지금까지 코팅을 사랑해주셔서 감사합니다."
            cell.date.text = "2021/05/12"
        case 1:
            cell.title.text = "[공지] 안드로이드 개발자를 구합니다."
            cell.date.text = "2021/05/11"
        case 2:
            cell.title.text = "[공지] 안녕하세요. 코팅입니다."
            cell.date.text = "2021/05/11"
        case 3:
            cell.title.text = "[공지] 코팅을 왜 만들었나요?"
            cell.date.text = "2021/05/11"
        case 4:
            cell.title.text = "[공지] 코팅 서비스 출시 !"
            cell.date.text = "2021/05/10"
        default:
            break
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
