//
//  NoticeDetailVC.swift
//  Koting
//
//  Created by 임정우 on 2021/05/11.
//

import UIKit

class NoticeDetailVC: UIViewController {
    
    var receivedNotice: Notice?
    

    @IBOutlet weak var noticeTitle: UILabel!
    @IBOutlet weak var noticeDate: UILabel!
    @IBOutlet weak var noticeContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    fileprivate func setUI() {
        
        guard let notice = receivedNotice else { return }
        
        noticeDate.textColor = .lightGray
        
        noticeTitle.text = notice.title
        noticeDate.text = notice.date
        noticeContent.text = notice.content
    }
    
}
