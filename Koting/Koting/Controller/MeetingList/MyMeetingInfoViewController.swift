//
//  MyMeetingInfoViewController.swift
//  Koting
//
//  Created by 홍화형 on 2021/05/07.
//

import UIKit

class MyMeetingInfoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var animalLabel: UILabel!
    @IBOutlet weak var collegeLabel: UILabel!
    @IBOutlet weak var mbtiLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    var meeting: Meeting?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
    }
    private func transAnimal(index: Int, isImage: Bool) -> String {
        if isImage {
            switch index {
            case 1: return "dog"
            case 2: return "cat"
            case 3: return "rabbit"
            case 4: return "fox"
            case 5: return "bear"
            case 6: return "dino"
            default: return "nil"
            }
        } else {
            switch index {
            case 1: return "강아지"
            case 2: return "고양이"
            case 3: return "토끼"
            case 4: return "여우"
            case 5: return "곰돌이"
            case 6: return "공룡"
            default: return "동물"
            }
        }
    }
}
