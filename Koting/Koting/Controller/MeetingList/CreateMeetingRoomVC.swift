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
    
    
    let participantsPicker = UIPickerView()
    let participantsArray: [String] = {
        let array: [String] = ["1 : 1", "2 : 2", "3 : 3", "4 : 4"]
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        participantsNumber.tintColor = UIColor.clear
        participantsNumber.delegate = self
        openKakaoTalkLink.delegate = self
        participantsNumber.becomeFirstResponder()
        
        createPicker()
    }
    
    
    @IBAction func createMeetingRoomBtnTapped(_ sender: Any) {
        guard checkTextFiled() == true else {
            self.makeAlertBox(title: "알림", message: "인원과 오픈 카카오톡 링크를 작성해 주세요.", text: "확인")
            return
        }
        createMeeting()
        
        // 여기서 나의 진행중인 미팅에 넘겨줘야함
        
    }
    
    func createMeeting() {
        CreateMeetingRoomAPI.shared.post(paramArray: MeetingRoomInfo) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let finalResult):
                let result = finalResult.result
                
                if result == "createFail" {
                    DispatchQueue.main.async {
                        strongSelf.makeAlertBox(title: "알림", message: "이미 개설된 미팅이 존재합니다.", text: "확인") { (action) in
                            strongSelf.dismiss(animated: true, completion: nil)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        strongSelf.makeAlertBox(title: "알림", message: "미팅을 개설했습니다.", text: "확인") { (action) in
                            strongSelf.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            case .failure:
                break
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == participantsNumber {
            participantsNumber.text = participantsArray[participantsPicker.selectedRow(inComponent: 0)]
        }
        return true
    }
}

// MARK:- PanModal 설정
extension CreateMeetingRoomVC: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(500)
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(500)
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
