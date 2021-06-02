//
//  CreateMeetingRoomVC.swift
//  Koting
//
//  Created by 홍화형 on 2021/03/25.
//

import Foundation
import UIKit
import PanModal

class CreateMeetingRoomVC: UIViewController {
    private let indicator = CustomIndicator()
    //MARK: Outlet설정
    @IBOutlet weak var shortComment: UITextView!
    @IBOutlet weak var createMeetingRoomBtn: UIButton!
    @IBOutlet var participantsButton: [UIButton]!
    
//    let participantsPicker = UIPickerView()
//    let participantsArray: [String] = {
//        let array: [String] = ["1 : 1", "2 : 2", "3 : 3", "4 : 4"]
//        return array
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        participantsNumber.tintColor = UIColor.clear
//        participantsNumber.delegate = self
        shortComment.delegate = self
        //participantsNumber.becomeFirstResponder()
        shortComment.layer.borderWidth = 0.5
        shortComment.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        shortComment.layer.cornerRadius = 10
        for button in participantsButton {
            button.layer.borderWidth = 0.5
            button.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            button.layer.cornerRadius = 10
        }
        createMeetingRoomBtn.layer.cornerRadius = 12
        placeholderSetting()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }
    
    
    @IBAction func createMeetingRoomBtnTapped(_ sender: Any) {
        guard checkTextFiled() == true else {
            self.makeAlertBox(title: "알림", message: "인원과 한 마디를 작성해 주세요.", text: "확인")
            return
        }
        createMeeting()
    }
    
    @IBAction func participantsButtonSelected(_ sender: UIButton) {
        participantsButton.forEach({ $0.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)})
        sender.tintColor = #colorLiteral(red: 0.9960784314, green: 0.4941176471, blue: 0.2117647059, alpha: 1)
    }
    
    func getParticipants() -> Participants {
        for (index, button) in participantsButton.enumerated() {
            if button.tintColor == #colorLiteral(red: 0.9960784314, green: 0.4941176471, blue: 0.2117647059, alpha: 1) {
                return Participants(rawValue: index) ?? .oneToOne
            }
        }
        return .oneToOne
    }
    func createMeeting() {
        indicator.startAnimating(superView: view)
        
        CreateMeetingRoomAPI.shared.post(numberOfParticipants: getParticipants().getNumberOfParticipants(), shortComment: shortComment) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let finalResult):
                let result = finalResult.result
                
                if result == "createFail" {
                    DispatchQueue.main.async {
                        strongSelf.indicator.stopAnimating()
                        strongSelf.makeAlertBox(title: "알림", message: "이미 개설된 미팅이 존재합니다.", text: "확인") { (action) in
                            strongSelf.dismiss(animated: true, completion: nil)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        strongSelf.indicator.stopAnimating()
                        strongSelf.makeAlertBox(title: "알림", message: "미팅을 개설했습니다.", text: "확인") { (action) in
                            strongSelf.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    strongSelf.indicator.stopAnimating()
                }
                break
            }
        }
    }
}

// MARK:- Picker 관련
extension CreateMeetingRoomVC {
    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return participantsArray.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return participantsArray[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        participantsNumber.text = participantsArray[row]
//    }
//
//    func createPicker(){
//        participantsPicker.delegate = self
//        participantsPicker.dataSource = self
//        participantsNumber.inputView = participantsPicker
//
//        createToolBar()
//    }
//
//    func createToolBar() {
//        let toolBar = UIToolbar()
//        let doneBtn = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(buttonAction))
//        doneBtn.tintColor = .black
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//        toolBar.sizeToFit()
//        toolBar.setItems([flexibleSpace,doneBtn], animated: true)
//        toolBar.isUserInteractionEnabled = true
//
//        participantsNumber.inputAccessoryView = toolBar
//    }
    //화면 클릭시 입력창 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
//
//    @objc func buttonAction() {
//        participantsNumber.resignFirstResponder()
//    }
    
    //MARK:- KEY BOARD 관련
    func addKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func removeKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(_ noti: NSNotification){
            panModalTransition(to: .longForm)
    }
    @objc func keyboardWillHide(_ noti: NSNotification){
            panModalTransition(to: .shortForm)
    }
}

// MARK:- TextFiled 관련
extension CreateMeetingRoomVC: UITextFieldDelegate, UITextViewDelegate {
    //글자수 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        return newLength<=50
    }
    func placeholderSetting() {
        shortComment.text = "50자 제한입니다."
        shortComment.textColor = UIColor.lightGray
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "50자 제한입니다."
            textView.textColor = UIColor.lightGray
        }
    }
}

// MARK:- PanModal 설정
extension CreateMeetingRoomVC: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(350)
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(600)
    }
    
    var anchorModalToLongForm: Bool {
        return true
    }
    
    var cornerRadius: CGFloat {
        get { return 0 }
    }
    
    var showDragIndicator: Bool {
        return false
    }
}

// MARK:- 추가구현 함수
extension CreateMeetingRoomVC {
    private func checkTextFiled() -> Bool {
        if shortComment.text == "" || shortComment.text.count > 50 || shortComment.text == "50자 제한입니다." {
            return false
        }
        
        return true
    }
}
