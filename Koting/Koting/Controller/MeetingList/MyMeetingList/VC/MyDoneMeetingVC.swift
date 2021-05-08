//
//  MyDoneMeetingVC.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/07.
//

import UIKit

class MyDoneMeetingVC: UIViewController {

    var doneMeeting = [Meeting]()
    
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

extension MyDoneMeetingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return doneMeeting.count
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoneMeetingCell", for: indexPath) as! DoneMeetingCell
        cell.animalShapeImage.image = UIImage(named: transImage(index: 2))
        cell.animalShapeImage.layer.cornerRadius = cell.animalShapeImage.frame.size.height/2
        cell.animalShapeImage.layer.masksToBounds = true
        cell.animalShapeImage.layer.borderWidth = 0
        cell.collegeLabel.text = "문과대학"
        cell.mbtiLabel.text = "INFP"
        cell.numberOfParticipants.text = "2:2"
        return cell
    }
    
}

extension MyDoneMeetingVC: UITableViewDelegate {
    
}
