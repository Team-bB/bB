//
//  AgreeVC.swift
//  Koting
//
//  Created by 임정우 on 2021/06/07.
//

import UIKit

class AgreeVC: UIViewController {

    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var agreeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    
    func setUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        textView1.layer.cornerRadius = 8
        textView2.layer.cornerRadius = 8
        textView1.layer.borderWidth = 0.3
        textView2.layer.borderWidth = 0.3
        textView1.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        textView2.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        agreeButton.setEnable()
    }

}
