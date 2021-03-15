//
//  ViewController.swift
//  EmailCertify
//
//  Created by 홍화형 on 2021/03/11.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    // MARK: IBOutlet 및 변수 ---------------------
    let grayColor = #colorLiteral(red: 0.7036006266, green: 0.7036006266, blue: 0.7036006266, alpha: 1)
    let orangeColor = #colorLiteral(red: 1, green: 0.6597687742, blue: 0.3187801202, alpha: 1)
    @IBOutlet weak var collegeTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var mbtiTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var okayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        okayButton.layer.cornerRadius = 10
        okayButton.backgroundColor = grayColor
    }
    
    // MARK: Alamofire --------------------
    private func postText() {
        let url = API.shared.BASE_URL + "/auth"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        //POST로 보낼 정보
        let params = ["college": collegeTextField.text,
                      "major": majorTextField.text,
                      "age": ageTextField.text,
                      "height": heightTextField.text,
                      "mbti": mbtiTextField.text,
                      "email": emailTextField.text] as Dictionary
        
        // httpBody에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success:
                print("POST 성공")
                debugPrint(response)
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
}

// MARK: TetxField -----------------------
extension ViewController: UITextFieldDelegate {
    
}
