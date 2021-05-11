//
//  NoticeVC.swift
//  Koting
//
//  Created by 임정우 on 2021/05/11.
//

import UIKit

fileprivate let reuseIdentifier = "cell"

class NoticeVC: UIViewController {
    
    let noticeList: [Notice] = [
        Notice(title: "[공지] 지금까지 코팅을 사랑해주셔서 감사합니다.", content: "이것은 내용입니다. 이것은 내용입니다. ", date: "2021/05/12"),
        Notice(title: "[공지] 안드로이드 개발자를 구합니다.", content: "이것은 내용입니다. 이것은 내용입니다. ", date: "2021/05/12"),
        Notice(title: "[공지] 지금까지 코팅을 사랑해주셔서 감사합니다.", content: "이것은 내용입니다. 이것은 내용입니다. ", date: "2021/05/12"),
        Notice(title: "[공지] 안녕하세요. 코팅입니다.", content: "이것은 내용입니다. 이것은 내용입니다. ", date: "2021/05/12"),
        Notice(title: "[공지] 코팅을 왜 만들었나요?", content: "이것은 내용입니다. 이것은 내용입니다. ", date: "2021/05/12"),
        Notice(title: "[공지] 코팅 서비스 출시 !", content: "이것은 내용입니다. 이것은 내용입니다. ", date: "2021/05/12"),
    ]
    let cellHeight: CGFloat = 80
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let noticeDetailVC = segue.destination as? NoticeDetailVC,
              let index = sender as? Int
        else {
            return
        }
        
        noticeDetailVC.receivedNotice = noticeList[index]
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
        tableView.tableFooterView = UIView()
//        tableView.reloadData()
    }
}

extension NoticeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoticeCell
        
        cell.date.textColor = .lightGray
        cell.title.text = noticeList[indexPath.row].title
        cell.date.text = noticeList[indexPath.row].date


        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "NoticeDetail", sender: indexPath.row)
    }
}
