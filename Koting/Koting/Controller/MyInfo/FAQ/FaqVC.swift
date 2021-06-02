//
//  FaqVC.swift
//  Koting
//
//  Created by 임정우 on 2021/05/28.
//

import UIKit

fileprivate let reuseIdentifier = "cell"

class FaqVC: UIViewController {
    
    let indicator = CustomIndicator()
    let cellHeight: CGFloat = 80
    let faqList = FaQModel().FaQList
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let faqDetailVC = segue.destination as? FaqDetailVC,
              let index = sender as? Int
        else {
            return
        }
        faqDetailVC.receivedFaQ = faqList[index]
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = cellHeight
        
        tableView.separatorInset.left = 20
        tableView.separatorInset.right = 20
        tableView.tableFooterView = UIView()
        
        tableView.reloadData()
    }
}

extension FaqVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = faqList[indexPath.row].title

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "FaqDetail", sender: indexPath.row)
    }
}
