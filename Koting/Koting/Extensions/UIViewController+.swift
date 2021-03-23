//
//  ViewTransition.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit

extension UIViewController {
    
    // Dismiss CurrentView
    func asyncDismissView() {
        DispatchQueue.main.async {
        
            self.dismiss(animated: true)
            
        }
    }
    
    func asyncPresentView(identifier `where`: String, style: UIModalPresentationStyle? = .fullScreen, animation: Bool? = true ) {
        DispatchQueue.main.async {
            
            guard let nextVC = self.storyboard?.instantiateViewController(identifier: `where`) else { return }
            
            nextVC.modalPresentationStyle = style!
            
            self.present(nextVC, animated: animation!)
            
        }
    }
    
    func makeAlertBox(title: String, message: String, text: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: text, style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(okButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
