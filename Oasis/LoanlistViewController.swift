//
//  LoanlistViewController.swift
//  Oasis
//
//  Created by mac on 2017. 1. 31..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class LoanlistViewController: UIViewController, LoanPageViewControllerDelegate {
    @IBOutlet weak var sum: UILabel!
    @IBOutlet weak var loancount: UILabel!
    @IBOutlet weak var donecount: UILabel!
    @IBOutlet weak var repaycount: UILabel!
    @IBOutlet weak var auctioncount: UILabel!
    @IBOutlet weak var taback: UIView!
    @IBOutlet weak var body: UIView!
    @IBAction func prev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    let realm = try! Realm()
    
    var tabname = ["신청", "정상", "경매대기", "경매진행", "상환"]
    var pageCon: LoanPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let pageController = storyboard?.instantiateViewController(withIdentifier: "LoanPageViewController") as? LoanPageViewController{
            
            pageCon = pageController
            
            addChildViewController(pageController)
            
            body.addSubview(pageController.view)
            
            constrainToBody(v: pageController.view)
            
            pageController.dele = self
        }
        
        
        
        setupTabar()
        
        popCommon()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectedPage(curIndex: Int) {
        onPageSelected(i: curIndex)
    }
    func popListDone() {
        
    }
    
    
    
    func popCommon(){
        
        let me = realm.objects(Member.self)[0]
        
        Alamofire.request("\(hj.url)app/api/loan/common/\(me._id)/").responseJSON { response in
            print(response.result)   // result of response serialization
            print(response.error ?? "")
            if let JSON = response.result.value  as? [String: Any] {
                // 에러 처리
                if let result = JSON["result"] as? [String:Any] {
                    if let err = result["error"] as! String?{
                        self.hj.showAlert(vc: self, msg: err); return
                    }
                }
                
                // 리턴 형식 정의
                let rslt = JSON["result"] as! [String:Any]
                
                self.sum.text = rslt["total_amount"] as? String ?? ""
                self.loancount.text = rslt["total_count"] as? String ?? ""
                self.donecount.text = rslt["sum_flag_state_10"] as? String ?? ""
                self.repaycount.text = rslt["sum_flag_state_30"] as? String ?? ""
                self.auctioncount.text = rslt["sum_flag_state_60_70"] as? String ?? ""
                
                
            } // end - response
        } // end - Alamofire
        
        
    }
    
    
    
    
    
    
    //make tab
    
    let tabar: UIView = UIView()
    var attrNorm: [String : Any] = [:]
    var attrSel: [String : Any] = [:]
    var tabs = [UIButton]()
    //var vcs: [LoanlistXViewController]?
    let tabarMarginTop: CGFloat = 55
    let tabarHeight: CGFloat = 35
    let hj = hjUtil()
    
    func setupTabar(){
        
        if let normFont = UIFont(name: "NotoSansKR-Regular", size: 14){
            attrNorm = [
                NSForegroundColorAttributeName : UIColor.black,
                NSShadowAttributeName : NSShadow(),
                NSFontAttributeName : normFont
            ]
        }
        if let selFont = UIFont(name: "NotoSansKR-Bold", size: 14){
            attrSel = [
                
                NSForegroundColorAttributeName : hj.rgb(0x0033a0),
                NSShadowAttributeName : NSShadow(),
                NSFontAttributeName : selFont
            ]
        }
        
        tabar.frame = CGRect(x: 0, y: tabarMarginTop, width: view.bounds.width, height: tabarHeight)
        
        addTabar()
        addBottomLine()
        
        //add tab
        let tabWidth = view.bounds.width / CGFloat(tabname.count)
        let tabHeight = tabar.bounds.height
        
        
        for i in 0...tabname.count-1 {
            
            var tab = UIButton()
            if i == 0 {
                tab = getTab(isFirst: true, isLast: false, title: tabname[i], tag: 0)
                
            }
            else if i == tabname.count - 1 { tab = getTab(isFirst: false, isLast: true, title: tabname[i], tag: tabname.count - 1) }
            else { tab = getTab(isFirst: false, isLast: false, title: tabname[i], tag: i) }
            
            tab.frame = CGRect(x: tabWidth * CGFloat(i), y: 0, width: tabWidth, height: tabHeight)
            
            tabs.append(tab)
            
            self.tabar.addSubview(tab)
            
            
        }
        
        
        onBtnClick( tabs[0] )
        
    }
    
    func addTabar(){
        
        tabar.translatesAutoresizingMaskIntoConstraints = false
        
        taback.addSubview(tabar)
        
        //constraint
        NSLayoutConstraint(item: tabar, attribute: .leading, relatedBy: .equal, toItem: taback, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: tabar, attribute: .top, relatedBy: .equal, toItem: taback, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: tabar, attribute: .trailing, relatedBy: .equal, toItem: taback, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: tabar, attribute: .bottom, relatedBy: .equal, toItem: taback, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
        
//        NSLayoutConstraint(item: tabar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: tabar.bounds.width).isActive = true
//        NSLayoutConstraint(item: tabar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: tabar.bounds.height).isActive = true
        
        
    }
    
    
    func addBottomLine(){
        let line = UIView()
        line.backgroundColor = hj.rgb(0x0033a0)
        line.translatesAutoresizingMaskIntoConstraints = false
        self.tabar.addSubview(line)
        
        //anchor
        
        line.leadingAnchor.constraint(equalTo: tabar.leadingAnchor, constant: 0).isActive = true
        line.trailingAnchor.constraint(equalTo: tabar.trailingAnchor, constant: 0).isActive = true
        line.bottomAnchor.constraint(equalTo: tabar.bottomAnchor, constant: 0).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
    }
    
    
    
    func getTab(isFirst: Bool, isLast: Bool, title: String, tag: Int) -> UIButton{
        
        let tab = UIButton()
        
        tab.setAttributedTitle(NSAttributedString(string: title, attributes: attrNorm), for: .normal)
        tab.setAttributedTitle(NSAttributedString(string: title, attributes: attrSel), for: .selected)
        
        tab.tag = tag
        
        tab.addTarget(self, action: #selector(self.onBtnClick(_:)), for: UIControlEvents.touchUpInside)
        
        if isFirst {
            
            tab.setBackgroundImage(UIImage(named: "btn_three_tab_01" ), for: UIControlState.selected)
        }else if isLast{
            tab.setBackgroundImage(UIImage(named: "btn_three_tab_02" ), for: UIControlState.selected)
        }else{
            tab.setBackgroundImage(UIImage(named: "btn_three_tab_03" ), for: UIControlState.selected)
        }
        
        return tab
    }
    
    func tabClear(){
        _ = tabs.map{ $0.isSelected = false }
    }
    
    func onBtnClick(_ sender : UIButton)
    {
        tabClear()
        sender.isSelected = true
        
        if let pageCon = pageCon{
            print("onBtnClick index=\(sender.tag)")
            pageCon.setViewControllers([pageCon.loanListXController(sender.tag)!], direction: .forward, animated: true, completion: nil)
        }
        
    }
    func onPageSelected(i: Int){
        tabClear()
        
        tabs[i].isSelected = true
        
    }
    
    func constrainToBody(v: UIView){
        
        v.translatesAutoresizingMaskIntoConstraints = false
        
        //constraint
        NSLayoutConstraint(item: v, attribute: .leading, relatedBy: .equal, toItem: body, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: v, attribute: .trailing, relatedBy: .equal, toItem: body, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: v, attribute: .top, relatedBy: .equal, toItem: body, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: v, attribute: .bottom, relatedBy: .equal, toItem: body, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
    }
    
    
    
    
    
    
    
    
}
