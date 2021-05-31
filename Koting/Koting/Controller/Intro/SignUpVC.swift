//
//  SignUpVC.swift
//  Koting
//
//  Created by 임정우 on 2021/03/24.
//

import UIKit
import NVActivityIndicatorView
import FirebaseAuth

class SignUpVC: UIViewController {
    
    let form: SignUpForm = SignUpForm()
    let indicator = CustomIndicator()

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
    @IBOutlet weak var nickName: UITextField!
    
    @IBOutlet var infoArray: Array<UITextField>!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        signUpButton.setDisable()
        
        registerForTextField()
        registerForKeyboardNotification()
        setPickerView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK:- @IBAction func
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard  let email = mail.text else { return }
        
        let totalEmail = email + form.mailDomain
        
        if (isValidEmail(totalEmail)) {
            indicator.startAnimating(superView: view)
            
            SignUpAPI.shared.post(paramArray: infoArray) { [weak self] result in
                
                guard let strongSelf = self else { return }
                switch result {
                case .success(let message):
                    
                    guard let animalIdx = UserDefaults.standard.value(forKey: "animalIndex") as? String else { return }
                    
                    let myInfo = Owner(college: strongSelf.college.text, major: strongSelf.major.text, sex: strongSelf.sex.text, mbti: strongSelf.MBTI.text, animal_idx: Int(animalIdx), age: Int(strongSelf.age.text!), height: Int(strongSelf.height.text!), nickname: strongSelf.nickName.text)
                    
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(myInfo), forKey:"myInfo")
                    UserDefaults.standard.set(message.result, forKey: "accountId")
                    UserDefaults.standard.set(message.result + strongSelf.form.mailDomain, forKey: "email")
                    UserDefaults.standard.set(false, forKey: "mailAuthChecked")
                    
                    // MARK: - Firebase 채팅서버 유저생성
                    strongSelf.createFirebaseUser(email: message.result + strongSelf.form.mailDomain, userInfo: myInfo)
                    
                    DispatchQueue.main.async {
                        strongSelf.indicator.stopAnimating()
                        let alertController = UIAlertController(title: "가입완료", message: "메일 인증후 이용가능합니다.", preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel) { action in
                            strongSelf.asyncPresentView(identifier: "GettingStarted")
                        }
                        
                        alertController.addAction(okButton)
                        
                        strongSelf.present(alertController, animated: true, completion: nil)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        strongSelf.indicator.stopAnimating()
                        let alertController = UIAlertController(title: "에러", message: "CodableError", preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel)
                        alertController.addAction(okButton)
                        strongSelf.present(alertController, animated: true, completion: nil)
                    }
                    print(error)
                }
            }
        } else {
            print("Not Valid !!!!!!!!!")
        }
    }
}

// MARK:- 추가 구현 함수들
extension SignUpVC {
    
    func setPickerView() {
        sex.inputView = sexPickerView
        college.inputView = collegePickerView
        major.inputView = majorPickerView
        MBTI.inputView = mbtiPikcerView
        age.inputView = agePickerView
        height.inputView = heightPickerView
        
        sex.delegate = self
        sex.tintColor = .clear
        college.delegate = self
        college.tintColor = .clear
        major.delegate = self
        major.tintColor = .clear
        MBTI.delegate = self
        MBTI.tintColor = .clear
        age.delegate = self
        age.tintColor = .clear
        height.delegate = self
        height.tintColor = .clear
        
        mail.delegate = self
        nickName.delegate = self
        
        
        sexPickerView.delegate = self
        collegePickerView.delegate = self
        majorPickerView.delegate = self
        mbtiPikcerView.delegate = self
        agePickerView.delegate = self
        heightPickerView.delegate = self
        
        sexPickerView.dataSource = self
        collegePickerView.dataSource = self
        majorPickerView.dataSource = self
        mbtiPikcerView.dataSource = self
        agePickerView.dataSource = self
        heightPickerView.dataSource = self
        
        sexPickerView.tag = 1
        collegePickerView.tag = 2
        majorPickerView.tag = 3
        mbtiPikcerView.tag = 4
        agePickerView.tag = 5
        heightPickerView.tag = 6
        
        createToolBar()
    }
    
    func registerForTextField() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidEndEditingNotification, object: sex)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidEndEditingNotification, object: college)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidEndEditingNotification, object: major)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidEndEditingNotification, object: age)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidEndEditingNotification, object: height)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidEndEditingNotification, object: MBTI)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: mail)
    }
    
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardHide(_ notification: Notification) {
            self.view.transform = .identity
    }
    
    @objc func keyBoardShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        
        if major.isEditing == true {
            keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: major)
        }
    }
    
    func keyboardAnimate(keyboardRectangle: CGRect ,textField: UITextField) {
        
        guard let textFieldMaxY = textField.superview?.superview?.frame.maxY else { return }
        
        if keyboardRectangle.height > (self.view.frame.height - textFieldMaxY) {
            self.view.transform = CGAffineTransform(translationX: 0, y: (self.view.frame.height - keyboardRectangle.height - textFieldMaxY))
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
        age.inputAccessoryView = toolBar
        height.inputAccessoryView = toolBar

    }
    
    @objc func buttonAction() {
        sex.resignFirstResponder()
        college.resignFirstResponder()
        major.resignFirstResponder()
        MBTI.resignFirstResponder()
        age.resignFirstResponder()
        height.resignFirstResponder()
    }
    
    func isNotEmptyTextFiled() -> Bool {
        return sex.text != "" && college.text != "" && major.text != "" && age.text != "" && height.text != "" && MBTI.text != "" && mail.text != "" && isValidNickname(nickName.text)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailPred.evaluate(with: email)
    }
    
    func isValidNickname(_ nickName: String?) -> Bool {
        guard let nickName = nickName else { return false }
        
        return nickName.count <= 8 && nickName.count > 0
    }
    
    // 채팅서버 createUser
    private func createFirebaseUser(email: String, password: String = "koting0000", userInfo: Owner) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult , error in
            guard let result = authResult, error == nil else {
                print("❌ Creating User 에러 발생 ❌")
                return
            }
            
            let chatUser = ChatAppUser(nickName: "\(userInfo.nickname!)",
                                       emailAddress: email,
                                       age: "\(userInfo.age!)살",
                                       college: userInfo.college!,
                                       major: userInfo.major!,
                                       mbti: userInfo.mbti!)
            
            DatabaseManager.shared.insertUser(with: chatUser) { success in
                
                // 프로필 이미지 업로드 가능함.
                print("💿 유저 데이터 저장완료 💿")
            }
            
            let user = result.user
            print("✅ 채팅서버 계정 생성 완료 ✅")
            print("채팅서버: 유저(\(user))")
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mail {
            mail.resignFirstResponder()
            nickName.becomeFirstResponder()
        } else if textField == nickName {
            nickName.resignFirstResponder()
            sex.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
            case sex:
                sex.text = form.sexArray[sexPickerView.selectedRow(inComponent: 0)]
            case college:
                college.text = form.collegeArray[collegePickerView.selectedRow(inComponent: 0)]
            case major:
                guard let college = college.text else { return false }
                
                switch college {
                    case "불교대학":
                        major.text = form.majorDict["불교대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "문과대학":
                        major.text = form.majorDict["문과대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "이과대학":
                        major.text = form.majorDict["이과대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "법과대학":
                        major.text = form.majorDict["법과대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "경영대학":
                        major.text = form.majorDict["경영대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "공과대학":
                        major.text = form.majorDict["공과대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "사범대학":
                        major.text = form.majorDict["사범대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "예술대학":
                        major.text = form.majorDict["예술대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "약학대학":
                        major.text = form.majorDict["약학대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "사회과학대학":
                        major.text = form.majorDict["사회과학대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "경찰사법대학":
                        major.text = form.majorDict["경찰사법대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "미래융합대학":
                        major.text = form.majorDict["미래융합대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    case "바이오시스템대학":
                        major.text = form.majorDict["바이오시스템대학"]![majorPickerView.selectedRow(inComponent: 0)]
                    
                    default: return false
                }
            case age:
                age.text = form.ageArray[agePickerView.selectedRow(inComponent: 0)]
            case height:
                height.text = form.heightArray[heightPickerView.selectedRow(inComponent: 0)]
            case MBTI:
                MBTI.text = form.mbtiArray[mbtiPikcerView.selectedRow(inComponent: 0)]

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
            return form.sexArray.count
        case 2:
            return form.collegeArray.count
        case 3:
            guard let college = college.text else { return 0 }
            
            switch college {
            case "불교대학": return form.majorDict["불교대학"]!.count
            case "문과대학": return form.majorDict["문과대학"]!.count
            case "이과대학": return form.majorDict["이과대학"]!.count
            case "법과대학": return form.majorDict["법과대학"]!.count
            case "경영대학": return form.majorDict["경영대학"]!.count
            case "공과대학": return form.majorDict["공과대학"]!.count
            case "사범대학": return form.majorDict["사범대학"]!.count
            case "예술대학": return form.majorDict["예술대학"]!.count
            case "약학대학": return form.majorDict["약학대학"]!.count
            case "사회과학대학": return form.majorDict["사회과학대학"]!.count
            case "경찰사법대학": return form.majorDict["경찰사법대학"]!.count
            case "미래융합대학": return form.majorDict["미래융합대학"]!.count
            case "바이오시스템대학": return form.majorDict["바이오시스템대학"]!.count
            
                
            default: return 0
            }
        case 4:
            return form.mbtiArray.count
        case 5:
            return form.ageArray.count
        case 6:
            return form.heightArray.count
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return form.sexArray[row]
        case 2:
            return form.collegeArray[row]
        case 3:
            guard let college = college.text else { return ""}
            
            switch college {
            case "불교대학": return form.majorDict["불교대학"]![row]
            case "문과대학": return form.majorDict["문과대학"]![row]
            case "이과대학": return form.majorDict["이과대학"]![row]
            case "법과대학": return form.majorDict["법과대학"]![row]
            case "경영대학": return form.majorDict["경영대학"]![row]
            case "공과대학": return form.majorDict["공과대학"]![row]
            case "사범대학": return form.majorDict["사범대학"]![row]
            case "예술대학": return form.majorDict["예술대학"]![row]
            case "약학대학": return form.majorDict["약학대학"]![row]
            case "사회과학대학": return form.majorDict["사회과학대학"]![row]
            case "경찰사법대학": return form.majorDict["경찰사법대학"]![row]
            case "미래융합대학": return form.majorDict["미래융합대학"]![row]
            case "바이오시스템대학": return form.majorDict["바이오시스템대학"]![row]
            
                
            default: return ""
            }
        case 4:
            return form.mbtiArray[row]
        case 5:
            return form.ageArray[row]
        case 6:
            return form.heightArray[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            sex.text = form.sexArray[row]
        case 2:
            college.text = form.collegeArray[row]
            major.text = ""
        case 3:
            guard let college = college.text else { return }
            
            switch college {
            case "불교대학":
                major.text =  form.majorDict["불교대학"]![row]
                major.resignFirstResponder()
            case "문과대학": major.text = form.majorDict["문과대학"]![row]
            case "이과대학": major.text = form.majorDict["이과대학"]![row]
            case "법과대학": major.text = form.majorDict["법과대학"]![row]
            case "경영대학": major.text = form.majorDict["경영대학"]![row]
            case "공과대학": major.text = form.majorDict["공과대학"]![row]
            case "사범대학": major.text = form.majorDict["사범대학"]![row]
            case "예술대학": major.text = form.majorDict["예술대학"]![row]
            case "약학대학": major.text = form.majorDict["약학대학"]![row]
            case "사회과학대학": major.text = form.majorDict["사회과학대학"]![row]
            case "경찰사법대학": major.text = form.majorDict["경찰사법대학"]![row]
            case "미래융합대학": major.text = form.majorDict["미래융합대학"]![row]
            case "바이오시스템대학": major.text = form.majorDict["바이오시스템대학"]![row]
            
            default: return
            }
        case 4:
            MBTI.text = form.mbtiArray[row]
        case 5:
            age.text = form.ageArray[row]
        case 6:
            height.text = form.heightArray[row]
        default:
            return
        }
    }
}
