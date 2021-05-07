//
//  MyContinueMeetingVC.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/07.
//

import UIKit

class MyContinueMeetingVC: UIViewController {

    var myApplies = [Meeting]()
    var myMeeting: MyMeeting?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

}

extension MyContinueMeetingVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return myApplies.count
        }else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMeetingApplicantCell", for: indexPath) as! MyMeetingApplicantCell
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyApplyCell", for: indexPath) as! MyApplyCell
            
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
