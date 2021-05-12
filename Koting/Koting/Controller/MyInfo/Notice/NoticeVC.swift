//
//  NoticeVC.swift
//  Koting
//
//  Created by 임정우 on 2021/05/11.
//

import UIKit

fileprivate let reuseIdentifier = "cell"

class NoticeVC: UIViewController {
    
    let indicator = CustomIndicator()
    let cellHeight: CGFloat = 80
    var noticeList: [Notice] = []
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        FetchNotices()
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
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
//        tableView.reloadData()
    }
    
    
    @objc private func didPullToRefresh() {
        print("Start Refresh")
        FetchNotices()
    }
    // MARK: FetchMeetings
    func FetchNotices() {
        
        if tableView.refreshControl?.isRefreshing == true {
            print("-----Refreshing Meetings-----\n")
        } else {
            indicator.startAnimating(superView: view)
            print("-----Fetching Meetings-----\n")
        }
        
        GetNoticeAPI.shared.get { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let finalResult):
                strongSelf.noticeList = finalResult.notice
                
                DispatchQueue.main.async {
                    strongSelf.indicator.stopAnimating()
                    strongSelf.tableView.refreshControl?.endRefreshing()
                    strongSelf.tableView.reloadData()
                }
                
            case .failure:
                DispatchQueue.main.async {
                    strongSelf.indicator.stopAnimating()
                    strongSelf.tableView.refreshControl?.endRefreshing()
                }
                break
            }
        }
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
