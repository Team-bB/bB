//
//  MeasureResultVC.swift
//  Koting
//
//  Created by 임정우 on 2021/05/29.
//

import UIKit

class MeasureResultVC: UIViewController {
    
    var percent: String?
    var animalFace: AnimalFace?
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var animalFaceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var remeasureButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    @IBAction func remeasureButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        presentAlert()
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "알림", message: "가입후 변경이 불가능합니다.\n사용하시겠습니까?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default) { [weak self] action in
            
            guard let strongSelf = self else { return }
            
            let animalIdx = strongSelf.animalFace?.getAnimalIndex()
            
            UserDefaults.standard.setValue(animalIdx, forKey: "animalIndex")
            strongSelf.performSegue(withIdentifier: "SignUp", sender: nil)
        }
        
        let cancelButton = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setUI() {
        guard let percent = percent, let animalFace = animalFace else { return }
        
        remeasureButton.setTitleColor(.white, for: .normal)
        remeasureButton.backgroundColor = .link
        remeasureButton.layer.cornerRadius = 12
        remeasureButton.layer.shadowColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1).cgColor
        remeasureButton.layer.shadowOpacity = 0.5
        remeasureButton.layer.shadowOffset = CGSize.zero
        remeasureButton.layer.shadowRadius = 4
        
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.8196078431, blue: 0.3450980392, alpha: 1)
        nextButton.layer.cornerRadius = 12
        nextButton.layer.shadowColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1).cgColor
        nextButton.layer.shadowOpacity = 0.5
        nextButton.layer.shadowOffset = CGSize.zero
        nextButton.layer.shadowRadius = 4
        
        imageView.image = animalFace.transToImage()
        resultLabel.text = "\(percent)%로 가장높게 나왔어요.😃"
        animalFaceLabel.text = "\(animalFace.rawValue)상"
        
        guard let text = resultLabel.text else { return }
        let attributeString = NSMutableAttributedString(string: text)
        
        let boldStr = String(text.split(separator: "%").first!) + "%"
        let font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        
        attributeString.addAttribute(.foregroundColor, value: UIColor.black, range: (text as NSString).range(of: boldStr))

        attributeString.addAttribute(.font, value: font, range: (text as NSString).range(of: boldStr))

        resultLabel.attributedText = attributeString


        

        
    }

}
