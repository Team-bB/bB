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
    
    override func viewDidLoad() {
        createMeetingRoomBtn.setDefault()
    }
    
    
    @IBAction func createMeetingRoomBtnTapped(_ sender: Any) {
//        meetingList.append(Meeting(numberOfParticipants: participantsNumber.text ?? "", progressCondition: "진행중", userInfo: Info(sex: "여", phoneNumber: "01012345678", college: "예술대학", major: "연극영화학과", age: "21", height: "163", mbti: "INTP", email: "kkkk@dgu.ac.kr")))
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



extension CreateMeetingRoomVC: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(300)
    }
    
    var anchorModalToLongForm: Bool {
        return true
    }
}
