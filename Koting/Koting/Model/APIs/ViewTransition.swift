//
//  ViewTransition.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import Foundation
import UIKit

func dismissView(`self`: UIViewController) {
    DispatchQueue.main.async {
        
        `self`.dismiss(animated: true)
        
    }
}

func goToView(withIdentifier: String, VC `self`: UIViewController, style: UIModalPresentationStyle? = .fullScreen, animation: Bool? = true) {
    
    DispatchQueue.main.async {
        
        guard let VC = `self`.storyboard?.instantiateViewController(identifier: withIdentifier) else { return }
        
        VC.modalPresentationStyle = style!
        
        `self`.present(VC, animated: animation!)
        
    }
}

func makeAlertBox(title: String, message: String, text: String, VC `self`: UIViewController) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let okButton = UIAlertAction(title: text, style: UIAlertAction.Style.cancel, handler: nil)
    alertController.addAction(okButton)
    
    return `self`.present(alertController, animated: true, completion: nil)
}
