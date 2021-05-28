//
//  FaqDetailVC.swift
//  Koting
//
//  Created by 임정우 on 2021/05/28.
//

import UIKit

class FaqDetailVC: UIViewController {
    
    var receivedFaQ: FaQ?
    
    @IBOutlet weak var faqTitle: UILabel!
    @IBOutlet weak var faqContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    fileprivate func setUI() {
        
        guard let faq = receivedFaQ else { return }
        
        faqTitle.text = faq.title
        faqContent.text = faq.content
    }

}
