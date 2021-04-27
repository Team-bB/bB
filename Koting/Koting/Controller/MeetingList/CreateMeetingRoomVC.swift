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
    //MARK: Outlet설정
    @IBOutlet weak var participantsNumber: UITextField!
    @IBOutlet weak var openKakaoTalkLink: UITextField!
    @IBOutlet weak var createMeetingRoomBtn: UIButton!
    @IBOutlet var MeetingRoomInfo: [UITextField]!
    
    let participantsArray: [String] = {
        let array: [String] = ["1 : 1", "2 : 2", "3 : 3", "4 : 4"]
        return array
    }()
    
    override func viewDidLoad() {
        
        participantsNumber.tintColor = UIColor.clear
        participantsNumber.delegate = self
        openKakaoTalkLink.delegate = self
        
        createMeetingRoomBtn.setDefault()
        createPicker()
//        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidEndEditingNotification, object: participantsNumber)
    }
    
    
    @IBAction func createMeetingRoomBtnTapped(_ sender: Any) {
//        meetingList.append(Meeting(numberOfParticipants: participantsNumber.text ?? "", progressCondition: "진행중", userInfo: Info(sex: "여", phoneNumber: "01012345678", college: "예술대학", major: "연극영화학과", age: "21", height: "163", mbti: "INTP", email: "kkkk@dgu.ac.kr")))
        
        guard checkTextFiled() else {
            self.makeAlertBox(title: "알림", message: "인원과 오픈 카카오톡 링크를 작성해 주세요.", text: "확인")
            return
        }
        self.dismiss(animated: true, completion: nil)
        //postMeetingRoomAndGetMeetingList() POST보내는 코드 잠시 주석...
    }
    func postMeetingRoomAndGetMeetingList() {
        CreateMeetingRoomAPI.shared.post(paramArray: MeetingRoomInfo) {
            result in
            switch result {
            case .success(let CreateMeetingRoomAPIResponse): break
                //미팅리스트 업데이트하는 코드 들어감.
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}

// MARK:- Picker 관련
extension CreateMeetingRoomVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return participantsArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return participantsArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        participantsNumber.text = participantsArray[row]
    }
    
    func createPicker(){
        let participantsPicker = UIPickerView()
        participantsPicker.delegate = self
        participantsPicker.dataSource = self
        participantsNumber.inputView = participantsPicker
        
        createToolBar()
    }
    
    func createToolBar() {
        let toolBar = UIToolbar()
        let doneBtn = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(buttonAction))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.sizeToFit()
        toolBar.setItems([flexibleSpace,doneBtn], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        participantsNumber.inputAccessoryView = toolBar
    }
    
    @objc func buttonAction() {
        participantsNumber.resignFirstResponder()
    }
}

// MARK:- TextFiled 관련
extension CreateMeetingRoomVC: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        return true
//    }
//
//    @objc func textDidChange(_ notification: Notification) {
//        if let _ = notification.object as? UITextField {
//            if participantsNumber.text != "" && openKakaoTalkLink.text != "" {
//                createMeetingRoomBtn.setEnable()
//            } else {
//                // Disable Button
//                createMeetingRoomBtn.setDisable()
//            }
//        }
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        participantsNumber.text = "1:1"
        return true
    }
}

// MARK:- PanModal 설정
extension CreateMeetingRoomVC: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(600)
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(600)
    }
    
    var anchorModalToLongForm: Bool {
        return true
    }
}

// MARK:- 추가구현 함수
extension CreateMeetingRoomVC {
    private func checkTextFiled() -> Bool {
        if participantsNumber.text == "" || openKakaoTalkLink.text == "" {
            return false
        }
        
        return true
    }
}
