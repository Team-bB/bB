//
//  MyMeetingViewController.swift
//  Koting
//
//  Created by 홍화형 on 2021/03/23.
//

import UIKit
import Alamofire
import PagingKit

class MyMeetingViewController: UIViewController {
    
    private var myMeeting: MyMeeting?
    private var applyList = [Meeting]()
    
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    
    static var viewController: (UIColor) -> UIViewController = { (color) in
        let vc = UIViewController()
        vc.view.backgroundColor = color
        return vc
    }

    var dataSource = [(menu: String, content: UIViewController)]() {
        didSet{
            menuViewController.reloadData()
            contentViewController.reloadData()
        }
    }
    
    lazy var firstLoad: (() -> Void)? = {[weak self,menuViewController,contentViewController] in
        menuViewController?.reloadData()
        contentViewController?.reloadData()
        self?.firstLoad = nil
    }
    
    override func viewDidLayoutSubviews() {
        firstLoad?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none //테이블 뷰 셀 줄 없애기
//        tableView.refreshControl = UIRefreshControl()
//        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        menuViewController.register(nib: UINib(nibName: "MenuCell", bundle: nil), forCellWithReuseIdentifier: "MenuCell")
        menuViewController.registerFocusView(nib: UINib(nibName: "FocusView", bundle: nil))
        
        menuViewController.cellAlignment = .center
        
        dataSource = makeDataSource()
        
        //FetchMeetings()
    }
 
    @objc private func didPullToRefresh() {
        print("Start Refresh")
        //FetchMeetings()
    }
 
//    func FetchMeetings() {
//        if tableView.refreshControl?.isRefreshing == true {
//            print("-----Refreshing MyMeetings-----\n")
//        }else {
//            print("-----Fetching MyMeetings-----\n")
//        }
//        MyMeetingListAPI.shared.get { [weak self] result in
//            guard let strongSelf = self else { return }
//            switch result {
//            case .success(let finalResult):
//                strongSelf.myMeeting = finalResult.myCreation
//                strongSelf.applyList = finalResult.myApplies
//
//
//                DispatchQueue.main.async {
//                    strongSelf.tableView.refreshControl?.endRefreshing()
//                    strongSelf.tableView.reloadData()
//                }
//
//            case .failure:
//                DispatchQueue.main.async {
//                    strongSelf.tableView.refreshControl?.endRefreshing()
//                }
//                break
//            }
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PagingMenuViewController {
            menuViewController = vc
            menuViewController.dataSource = self //<- set menu data source
            menuViewController.delegate = self
        }else if let vc = segue.destination as? PagingContentViewController {
            contentViewController = vc
            contentViewController.dataSource = self
            contentViewController.delegate = self
        }
    }
    
    fileprivate func makeDataSource() -> [(menu: String, content: UIViewController)] {
        let myMenuArray = ["진행중인 미팅", "완료된 미팅"]
        return myMenuArray.map{
            let title = $0
            
            switch title {
            case "진행중인 미팅":
                let vc = UIStoryboard(name: "MyMeetingList",bundle: nil).instantiateViewController(identifier: "MyContinueMeetingVC") as! MyContinueMeetingVC
                return (menu: title, content: vc)
            case "완료된 미팅":
                let vc = UIStoryboard(name: "MyMeetingList",bundle: nil).instantiateViewController(identifier: "MyDoneMeetingVC") as! MyDoneMeetingVC
                return (menu: title, content: vc)
            default:
                let vc = UIStoryboard(name: "MyMeetingList",bundle: nil).instantiateViewController(identifier: "MyDoneMeetingVC") as! MyDoneMeetingVC
                return (menu: title, content: vc)
            }
        }
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
//MARK: - 메뉴 데이터
extension MyMeetingViewController: PagingMenuViewControllerDataSource{
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource.count
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: index) as! MenuCell
        cell.titleLabel.text = dataSource[index].menu
        //cell.titleLabel.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        return cell
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return view.frame.width/2
    }
    
    
}

extension MyMeetingViewController: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
    }
    
    
}

//MARK: - 콘텐트 데이터
extension MyMeetingViewController: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource[index].content
    }
}

extension MyMeetingViewController: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        //내용이 스크롤 되면 메뉴를 스크롤 한다.
        menuViewController.scroll(index: index, percent: percent, animated: false)
    }
}

//extension MyMeetingViewController: ExpyTableViewDataSource, ExpyTableViewDelegate {
//    //MARK: - ExpyTableView
//    func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
//        if section == 0 {
//            return true
//        } else { return false } // 내 미팅 지원자 목록(section 0)만 expandable하게 만듬.
//    }
//
//    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
//        if section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMeetingCell") as! MyMeetingTableViewCell
////            cell.tableViewCellLayer.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
//            cell.tableViewCellLayer.layer.cornerRadius = 20
////            cell.tableViewCellLayer.layer.borderWidth = 2
////            cell.tableViewCellLayer.layer.masksToBounds = true
//
//            cell.collegeName.text = myMeeting?.myMeeting.owner?.college
//            cell.numberOfParticipants.text = myMeeting?.myMeeting.player
//            cell.animalShapeImage.image = UIImage(named: transImage(index: myMeeting?.myMeeting.owner?.animal_idx ?? 0))
//            cell.animalShapeImage.layer.cornerRadius = cell.animalShapeImage.frame.size.height/2
//            cell.animalShapeImage.layer.masksToBounds = true
//            cell.animalShapeImage.layer.borderWidth = 0
//
//            cell.tableViewCellLayer.layer.shadowColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1).cgColor
//            cell.tableViewCellLayer.layer.shadowOpacity = 1.0
//            cell.tableViewCellLayer.layer.shadowOffset = CGSize.zero
//            cell.tableViewCellLayer.layer.shadowRadius = 6
//
//            let bgView = UIView()
//            bgView.backgroundColor = .white
//            cell.selectedBackgroundView = bgView
//
//            return cell
//        } else { return UITableViewCell() }
//    }
//
//    func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
//        switch state {
//        case .willExpand:
//            print("펼쳐질 꺼다/ .willExpand")
//        case .willCollapse:
//            print("닫힐 꺼다/ .willCollapse")
//        case .didExpand:
//            print("펼쳐짐/ .didExpand")
//        case .didCollapse:
//            print("닫힘/ .didCollapse")
//        }
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 { return "내 여친 후보들!"}
//        else { return "내가 지원한 미팅"}
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return myMeeting?.participant.count ?? 0 + 1
//        }else if section == 1{
//            return applyList.count
//        }else {
//            return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingParticipantsCell", for: indexPath) as! MeetingParticipantsCell
//            cell.tableViewCellLayer.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
//            cell.tableViewCellLayer.layer.cornerRadius = 20
//            cell.tableViewCellLayer.layer.borderWidth = 2
//            cell.tableViewCellLayer.layer.masksToBounds = true
//
//            cell.collegeName.text = myMeeting?.participant[indexPath.row].college
//            cell.mbtiText.text = myMeeting?.participant[indexPath.row].mbti
//            cell.animalShapeImage.image = UIImage(named: transImage(index: myMeeting?.participant[indexPath.row].animal_idx ?? 0))
//            cell.animalShapeImage.layer.cornerRadius = cell.animalShapeImage.frame.size.height/2
//            cell.animalShapeImage.layer.masksToBounds = true
//            cell.animalShapeImage.layer.borderWidth = 0
//
//            let bgView = UIView()
//            bgView.backgroundColor = .white
//            cell.selectedBackgroundView = bgView
//
//            return cell
//        }else if indexPath.section == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ApplyListCell", for: indexPath) as! ApplyListTableViewCell
//            cell.tableViewCellLayer.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
//            cell.tableViewCellLayer.layer.cornerRadius = 20
//            cell.tableViewCellLayer.layer.borderWidth = 2
//            cell.tableViewCellLayer.layer.masksToBounds = true
//
//            cell.collegeName.text = applyList[indexPath.row].owner?.college
//            cell.numberOfParticipants.text = applyList[indexPath.row].player
//            cell.animalShapeImage.image = UIImage(named: transImage(index: applyList[indexPath.row].owner?.animal_idx ?? 0))
//            cell.animalShapeImage.layer.cornerRadius = cell.animalShapeImage.frame.size.height/2
//            cell.animalShapeImage.layer.masksToBounds = true
//            cell.animalShapeImage.layer.borderWidth = 0
//
//            let bgView = UIView()
//            bgView.backgroundColor = .white
//            cell.selectedBackgroundView = bgView
//
//            return cell
//        }else {
//            return UITableViewCell()
//        }
//
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        ///
//    }
//
//    func transImage(index: Int) -> String {
//        switch index {
//        case 1: return "dog"
//        case 2: return "cat"
//        case 3: return "rabbit"
//        case 4: return "fox"
//        case 5: return "bear"
//        case 6: return "dino"
//        default: return "nil"
//        }
//    }
//}
