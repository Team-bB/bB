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
    
//    private var myMeeting: MyMeeting?
//    private var applyList = [Meeting]()
    
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

        menuViewController.register(nib: UINib(nibName: "MenuCell", bundle: nil), forCellWithReuseIdentifier: "MenuCell")
        menuViewController.registerFocusView(nib: UINib(nibName: "FocusView", bundle: nil))
        
        menuViewController.cellAlignment = .center
        
        dataSource = makeDataSource()
        
    }
 
    
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
