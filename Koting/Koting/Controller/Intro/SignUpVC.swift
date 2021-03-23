//
//  SignUpVC.swift
//  Koting
//
//  Created by 임정우 on 2021/03/24.
//

import UIKit

class SignUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.setDefault()
        signUpButton.setDisable()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidEndEditingNotification, object: sex)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidEndEditingNotification, object: college)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidEndEditingNotification, object: major)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidEndEditingNotification, object: age)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidEndEditingNotification, object: height)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidEndEditingNotification, object: MBTI)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: mail)
        
        // MARK:- PickerView 관련
        sex.inputView = sexPickerView
        college.inputView = collegePickerView
        major.inputView = majorPickerView
        MBTI.inputView = mbtiPikcerView
        age.inputView = agePickerView
        height.inputView = heightPickerView
        
        sex.delegate = self
        college.delegate = self
        major.delegate = self
        MBTI.delegate = self
        age.delegate = self
        height.delegate = self
        mail.delegate = self
        
        sexPickerView.tag = 1
        collegePickerView.tag = 2
        majorPickerView.tag = 3
        mbtiPikcerView.tag = 4
        agePickerView.tag = 5
        heightPickerView.tag = 6
    }
    
    
    // MARK:- PickerView 선언
    var sexPickerView = UIPickerView()
    var collegePickerView = UIPickerView()
    var majorPickerView = UIPickerView()
    var mbtiPikcerView = UIPickerView()
    var agePickerView = UIPickerView()
    var heightPickerView = UIPickerView()
    
    // MARK:- @IBOutlet
    @IBOutlet weak var sex: UITextField!
    @IBOutlet weak var college: UITextField!
    @IBOutlet weak var major: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var MBTI: UITextField!
    @IBOutlet weak var mail: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK:- @IBAction func
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard  let email = mail.text else { return }
        
        if (isValidEmail(email + domain)) {
            print("ValidEmail !!")
            // post
        } else {
            print("Not Valid !!!!!!!!!")
        }
    }
}

// MARK:- 추가 구현 함수들
extension SignUpVC {
    
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
        age.inputAccessoryView = toolBar
        height.inputAccessoryView = toolBar
//        mail.inputAccessoryView = toolBar
    }
    
    @objc func buttonAction() {
        sex.resignFirstResponder()
        college.resignFirstResponder()
        major.resignFirstResponder()
        MBTI.resignFirstResponder()
        age.resignFirstResponder()
        height.resignFirstResponder()
//        mail.resignFirstResponder()
    }
    
    func isNotEmptyTextFiled() -> Bool {
        return sex.text != "" && college.text != "" && major.text != "" && age.text != "" && height.text != "" && MBTI.text != "" && mail.text != ""
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

// MARK:- TextFieldDelegate 관련 메소드
extension SignUpVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    @objc func textDidChange(_ notification: Notification) {
        if let _ = notification.object as? UITextField {
            if isNotEmptyTextFiled() {
                signUpButton.setEnable()

            } else {
                // Disable Button
                signUpButton.setDisable()
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
            case sex:
                sex.text = sexArray[sexPickerView.selectedRow(inComponent: 0)]
            case college:
                college.text = collegeArray[collegePickerView.selectedRow(inComponent: 0)]
            case major:
                guard let college = college.text else { return false }
                
                switch college {
                    case "불교대학":
                        major.text = majorDict["불교대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "문과대학":
                        major.text = majorDict["문과대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "이과대학":
                        major.text = majorDict["이과대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "법과대학":
                        major.text = majorDict["법과대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "경영대학":
                        major.text = majorDict["경영대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "공과대학":
                        major.text = majorDict["공과대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "사범대학":
                        major.text = majorDict["사범대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "예술대학":
                        major.text = majorDict["예술대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "약학대학":
                        major.text = majorDict["약학대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "사회과학대학":
                        major.text = majorDict["사회과학대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "경찰사법대학":
                        major.text = majorDict["경찰사법대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "미래융합대학":
                        major.text = majorDict["미래융합대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "바이오시스템대학":
                        major.text = majorDict["바이오시스템대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    
                    default: return false
                }
            case age:
                age.text = ageArray[agePickerView.selectedRow(inComponent: 0)]
            case height:
                height.text = heightArray[heightPickerView.selectedRow(inComponent: 0)]
            case MBTI:
                MBTI.text = mbtiArray[mbtiPikcerView.selectedRow(inComponent: 0)]

            default:
                return true
        }
        return true
    }
    
}

// MARK:- PickerViewDataSource 관련 메소드
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
        case 5:
            return ageArray.count
        case 6:
            return heightArray.count
            
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
        case 5:
            return ageArray[row]
        case 6:
            return heightArray[row]
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
        case 5:
            age.text = ageArray[row]
        case 6:
            height.text = heightArray[row]
        default:
            return
        }
    }
}
