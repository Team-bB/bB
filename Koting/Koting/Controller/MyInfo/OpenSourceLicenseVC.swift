//
//  OpenSourceLicenseVC.swift
//  Koting
//
//  Created by 임정우 on 2021/06/03.
//

import UIKit

class OpenSourceLicenseVC: UIViewController {
    
    let license = OpenSourceLicenseModel()
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = license.text
        guard let text = textView.text else { return }
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .regular), range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSMakeRange(0, attributeString.length))
        for name in license.list {
            let boldStr = name
            let font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            attributeString.addAttribute(.font, value: font, range: (text as NSString).range(of: boldStr))
        }
        
        textView.attributedText = attributeString

    }

    @IBAction func buttonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
