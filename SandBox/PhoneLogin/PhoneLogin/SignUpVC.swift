//
//  SignUpVC.swift
//  PhoneLogin
//
//  Created by 임정우 on 2021/03/17.
//

import UIKit
import Alamofire

class SignUpVC: UIViewController {
    // MARK: 변수    -----------------------
    let grayColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    let orangeColor = #colorLiteral(red: 1, green: 0.6597687742, blue: 0.3187801202, alpha: 1)
    
    private let domain = "@dgu.ac.kr"
    private let sexArray = ["", "남자", "여자"]
    private let collegeArray = ["", "불교대학",
                        "문과대학",
                        "이과대학",
                        "법과대학",
                        "사회과학대학",
                        "경찰사법대학",
                        "경영대학",
                        "바이오시스템대학",
                        "공과대학",
                        "사범대학",
                        "예술대학",
                        "약학대학",
                        "미래융합대학"]
    
    private let majorDict: [String:[String]] = [
        "불교대학" : ["", "불교학부"],
        "문과대학" : ["", "국어국문문예창작학부","영어문학전공","영어통번역학전공","일본학과","중어중문학과","철학과","사학과","윤리문화학전공"],
        "이과대학" : ["", "수학과","화학과","통계학과","물리반도체과학부"],
        "법과대학" : ["", "법학과"],
        "사회과학대학" : ["", "정치외교학전공","행정학전공","북한학전공","경제학과","국제통상학과","사회학전공","미디어커뮤니케이션전공","식품산업관리학과","광고홍보학과","사회복지학과"],
        "경찰사법대학" : ["", "경찰행정학부"],
        "경영대학" : ["", "경영학과","회계학과","경영정보학과"],
        "바이오시스템대학" : ["", "바이오환경과학과","생명과학과","식품생명공학과","의생명공학과"],
        "공과대학" : ["", "건설환경공학과","건축학전공","건축공학전공","기계로봇에너지공학과","멀티미디어공학과","산업시스템공학과","융합에너지신소재공학과","전자전기공학부","정보통신공학전공","컴퓨터공학전공","화공생물공학과"],
        "사범대학" : ["", "교육학과","국어교육과","역사교육과","지리교육과","수학교육과","가정교육과","체육교육과"],
        "예술대학" : ["", "미술학부","연극학부","영상영화학과","스포츠문화학과"],
        "약학대학" : ["", "약학과"],
        "미래융합대학" : ["", "융합보안학과","사회복지상담학과","글로벌무역학과"]
    ]
    
    private let mbtiArray = ["", "ENFJ",
                     "ENFP",
                     "ENTJ",
                     "ENTP",
                     "ESFJ",
                     "ESFP",
                     "ESTJ",
                     "ESTP",
                     "INFJ",
                     "INFP",
                     "INTJ",
                     "INTP",
                     "ISFJ",
                     "ISFP",
                     "ISTJ",
                     "ISTP"]
    
    // MARK: PickerView
    var sexPickerView = UIPickerView()
    var collegePickerView = UIPickerView()
    var majorPickerView = UIPickerView()
    var mbtiPikcerView = UIPickerView()
    
    // MARK: OUTLET -----------------------
    @IBOutlet weak var sex: UITextField!
    @IBOutlet weak var college: UITextField!
    @IBOutlet weak var major: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var MBTI: UITextField!
    @IBOutlet weak var mail: UITextField!

    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = 10
        signUpButton.backgroundColor = .opaqueSeparator
        
        // MARK: Notification - TextField 관련
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: sex)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: college)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: major)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: age)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: height)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: mail)

        // MARK: PickerView 관련
        sex.inputView = sexPickerView
        college.inputView = collegePickerView
        major.inputView = majorPickerView
        MBTI.inputView = mbtiPikcerView
        
        sexPickerView.delegate = self
        collegePickerView.delegate = self
        majorPickerView.delegate = self
        mbtiPikcerView.delegate = self
        
        sexPickerView.dataSource = self
        collegePickerView.dataSource = self
        majorPickerView.dataSource = self
        mbtiPikcerView.dataSource = self
        
        sexPickerView.tag = 1
        collegePickerView.tag = 2
        majorPickerView.tag = 3
        mbtiPikcerView.tag = 4

        
        createToolBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    // MARK: IBAction func -----------------
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard  let email = mail.text else { return }
        if (isValidEmail(email + domain)) {
            print("ValidEmail !!")
        } else {
            print("Not Valid !!!!!!!!!")
        }
    }
    
}

// MARK: 추가 구현 함수들
extension SignUpVC {
    private func postText() {
        let url = API.shared.BASE_URL + "/auth"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        //POST로 보낼 정보
        guard let sex = sex.text, let phoneNumber = API.shared.phoneNumber, let college = college.text, let major = major.text, let age = age.text, let height = height.text, let MBTI = MBTI.text, let mail = mail.text else { return }
        
        let params = [
                        "sex" : sex,
                        "phoneNumber" : phoneNumber,
                        "college": college,
                        "major": major,
                        "age": age,
                        "height": height,
                        "mbti": MBTI,
                        "email": mail + domain
                    ] as Dictionary
        
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
    
    private func createToolBar() {
        
        let toolBar = UIToolbar()
        let doneBtn = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(buttonAction))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        
        toolBar.sizeToFit()
        toolBar.setItems([flexibleSpace,doneBtn], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        sex.inputAccessoryView = toolBar
        college.inputAccessoryView = toolBar
        major.inputAccessoryView = toolBar
        MBTI.inputAccessoryView = toolBar
    }
    
    @objc func buttonAction() {
        sex.resignFirstResponder()
        college.resignFirstResponder()
        major.resignFirstResponder()
        MBTI.resignFirstResponder()
    }
    
    func isNotEmptyTextFiled() -> Bool {
        if sex.text != "" && college.text != "" && major.text != "" && age.text != "" && height.text != "" && MBTI.text != "" && mail.text != "" {
            return true
        }
//        guard let sex = sex.text, let college = college.text, let major = major.text, let age = age.text, let height = height.text, let MBTI = MBTI.text, let mail = mail.text else { return false }
//
        return false
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

// MARK: TextFieldDelegate 관련 메소드 ------------------------
extension SignUpVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }

    @objc private func textDidChange(_ notification: Notification) {
        if let _ = notification.object as? UITextField {
            if isNotEmptyTextFiled() {
                // Enable Button
                signUpButton.isEnabled = true
                signUpButton.backgroundColor = orangeColor

            } else {
                // Disable Button
                signUpButton.isEnabled = false
                signUpButton.backgroundColor = .opaqueSeparator
            }
        }
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        let index = 0
//
//    }
}

// MARK: PickerViewDataSource 관련 메소드 ------------------------
extension SignUpVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return sexArray.count
        case 2:
            return collegeArray.count
        case 3:
            guard let college = college.text else { return 0 }
            
            switch college {
            case "불교대학": return majorDict["불교대학"]!.count
            case "문과대학": return majorDict["문과대학"]!.count
            case "이과대학": return majorDict["이과대학"]!.count
            case "법과대학": return majorDict["법과대학"]!.count
            case "경영대학": return majorDict["경영대학"]!.count
            case "공과대학": return majorDict["공과대학"]!.count
            case "사범대학": return majorDict["사범대학"]!.count
            case "예술대학": return majorDict["예술대학"]!.count
            case "약학대학": return majorDict["약학대학"]!.count
            case "사회과학대학": return majorDict["사회과학대학"]!.count
            case "경찰사법대학": return majorDict["경찰사법대학"]!.count
            case "미래융합대학": return majorDict["미래융합대학"]!.count
            case "바이오시스템대학": return majorDict["바이오시스템대학"]!.count
            
                
            default: return 0
            }
        case 4:
            return mbtiArray.count
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return sexArray[row]
        case 2:
            return collegeArray[row]
        case 3:
            guard let college = college.text else { return ""}
            
            switch college {
            case "불교대학": return majorDict["불교대학"]![row]
            case "문과대학": return majorDict["문과대학"]![row]
            case "이과대학": return majorDict["이과대학"]![row]
            case "법과대학": return majorDict["법과대학"]![row]
            case "경영대학": return majorDict["경영대학"]![row]
            case "공과대학": return majorDict["공과대학"]![row]
            case "사범대학": return majorDict["사범대학"]![row]
            case "예술대학": return majorDict["예술대학"]![row]
            case "약학대학": return majorDict["약학대학"]![row]
            case "사회과학대학": return majorDict["사회과학대학"]![row]
            case "경찰사법대학": return majorDict["경찰사법대학"]![row]
            case "미래융합대학": return majorDict["미래융합대학"]![row]
            case "바이오시스템대학": return majorDict["바이오시스템대학"]![row]
            
                
            default: return ""
            }
        case 4:
            return mbtiArray[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            sex.text = sexArray[row]
        case 2:
            college.text = collegeArray[row]
            major.text = ""
        case 3:
            guard let college = college.text else { return }
            
            switch college {
            case "불교대학":
                major.text =  majorDict["불교대학"]![row]
                major.resignFirstResponder()
            case "문과대학": major.text = majorDict["문과대학"]![row]
            case "이과대학": major.text = majorDict["이과대학"]![row]
            case "법과대학": major.text = majorDict["법과대학"]![row]
            case "경영대학": major.text = majorDict["경영대학"]![row]
            case "공과대학": major.text = majorDict["공과대학"]![row]
            case "사범대학": major.text = majorDict["사범대학"]![row]
            case "예술대학": major.text = majorDict["예술대학"]![row]
            case "약학대학": major.text = majorDict["약학대학"]![row]
            case "사회과학대학": major.text = majorDict["사회과학대학"]![row]
            case "경찰사법대학": major.text = majorDict["경찰사법대학"]![row]
            case "미래융합대학": major.text = majorDict["미래융합대학"]![row]
            case "바이오시스템대학": major.text = majorDict["바이오시스템대학"]![row]
            
            default: return
            }
        case 4:
            MBTI.text = mbtiArray[row]
        default:
            return
        }
    }
}
