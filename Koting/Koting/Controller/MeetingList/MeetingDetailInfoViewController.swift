//
//  MeetingDetailInfoViewController.swift
//  Koting
//
//  Created by 홍화형 on 2021/03/23.
//

import UIKit

class MeetingDetailInfoViewController: UIViewController {

    @IBOutlet weak var meetingInfoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var applyBtnTapped: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.meetingInfoView.layer.borderColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        self.meetingInfoView.layer.cornerRadius = 20
        self.meetingInfoView.layer.borderWidth = 2
        self.applyBtnTapped.layer.borderColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        self.applyBtnTapped.layer.cornerRadius = 10
        self.applyBtnTapped.layer.borderWidth = 1
        self.imageView.image = UIImage(named: "image")
        self.imageView.layer.cornerRadius = imageView.frame.width/2
        self.imageView.layer.borderWidth = 1
        self.imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
        self.imageView.layer.borderColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        self.imageView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
