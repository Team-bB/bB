//
//  ViewController.swift
//  AlertBoxTest
//
//  Created by 임정우 on 2021/03/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func buttonTapped(_ sender: Any) {
        makeAlertBox(title: "Test", message: "This is test", text: "확인")
    }
    func makeAlertBox(title: String, message: String, text: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: text, style: UIAlertAction.Style.cancel) { action in
            
            self.makeAlertBox(title: "테스트", message: "성공", text: "확인")
            
        }
        alertController.addAction(okButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
}



