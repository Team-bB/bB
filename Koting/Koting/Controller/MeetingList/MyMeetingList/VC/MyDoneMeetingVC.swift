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

        // Do any additional setup after loading the view.
    }

}

extension MyDoneMeetingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneMeeting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoneMeetingCell", for: indexPath) as! DoneMeetingCell
        return cell
    }
    
}

extension MyDoneMeetingVC: UITableViewDelegate {
    
}
