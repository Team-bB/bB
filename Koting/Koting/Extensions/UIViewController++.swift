//
//  UIViewController++.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import UIKit
import NVActivityIndicatorView

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
    
    func makeAlertBox(title: String, message: String, text: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: text, style: .default, handler: handler)
        alertController.addAction(okButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            DispatchQueue.main.async {
                v?.isHidden = !s
            }
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }
}
