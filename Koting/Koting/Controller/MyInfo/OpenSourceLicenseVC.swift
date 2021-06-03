//
//  OpenSourceLicenseVC.swift
//  Koting
//
//  Created by 임정우 on 2021/06/03.
//

import UIKit

class OpenSourceLicenseVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func buttonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
