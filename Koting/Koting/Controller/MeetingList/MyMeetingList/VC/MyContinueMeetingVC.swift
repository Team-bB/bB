//
//  MyContinueMeetingVC.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/07.
//

import UIKit

class MyContinueMeetingVC: UIViewController {

    var myApplies = [Meeting]()
    //var myMeeting: MyMeeting?
    var myMeeting: MyMeeting = MyMeeting(myMeeting: Meeting(owner: Owner(college: "이과대학", major: "화학과", sex: "남", mbti: "ENTP", animal_idx: 1, age: 22, height: 176), meeting_id: 111, link: "adsf", player: "3:#"),
                                         participant: [Owner(college: "공과대학", major: "정보통신공학과", sex: "여", mbti: "INFP", animal_idx: 3, age: 20, height: 150),
                                                       Owner(college: "문과대학", major: "국어문예창작학부", sex: "여", mbti: "ESFP", animal_idx: 4, age: 27, height: 155),
                                                       Owner(college: "사회과학대학", major: "경제학과", sex: "여", mbti: "INTF", animal_idx: 2, age: 24, height: 160)])

    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func transImage(index: Int) -> String {
        switch index {
        case 1: return "dog"
        case 2: return "cat"
        case 3: return "rabbit"
        case 4: return "fox"
        case 5: return "bear"
        case 6: return "dino"
        default: return "nil"
        }
    }


}

extension MyContinueMeetingVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 3
        }else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMeetingApplicantCell", for: indexPath) as! MyMeetingApplicantCell
            if myMeeting.participant.count == 0 {
                return UITableViewCell()
            }
            cell.collectionView.tag = indexPath.row
            cell.myMeeting = myMeeting
            cell.setColleciontionViewWith()
            cell.acceptButtonPressed = { [unowned self] in
                let alert = UIAlertController(title: "신청되었습니다!", message: "상대방에게 신청 완료되었습니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
//            cell.rejectButtonPressed = { [unowned self] in
//                let height = self.myMeeting.participant[indexPath.row].height
//                let alert = UIAlertController(title: "거절되었습니다!", message: "상대방 신청을 거절했습니다.", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
//                alert.addAction(okAction)
//                self.present(alert, animated: true, completion: nil)
//                print(height ?? "0")
//
//            }
            
            let bgView = UIView()
            bgView.backgroundColor = .white
            cell.selectedBackgroundView = bgView
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyApplyCell", for: indexPath) as! MyApplyCell
            cell.animalShapeImage.image = UIImage(named: transImage(index: 1))
            cell.animalShapeImage.layer.cornerRadius = cell.animalShapeImage.frame.size.height/2
            cell.animalShapeImage.layer.masksToBounds = true
            cell.animalShapeImage.layer.borderWidth = 0
            cell.collegeLabel.text = "사회과학대학"
            cell.mbtiLabel.text = "ESTP"
            cell.numberOfParticipants.text = "3:3"
            cell.progressLabel.text = "거절됨"
            cell.progressLabel.textColor = #colorLiteral(red: 1, green: 0.1289727639, blue: 0.1503030388, alpha: 1)
            
            let bgView = UIView()
            bgView.backgroundColor = .white
            cell.selectedBackgroundView = bgView

            return cell
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "받은 신청"}
        else { return "지원한 미팅"}
    }
}

extension MyContinueMeetingVC: UITableViewDelegate {
    
}
