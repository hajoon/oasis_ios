//
//  SelPartner.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 18..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

protocol SelPartnerDelegate{
    func cancel(sender: SelPartner)
    func next(sender: SelPartner)
}

class SelPartner: UIViewController, UITabBarDelegate {

    @IBOutlet weak var titleTop: UILabel!
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tabarBack: UIView!
    @IBOutlet weak var tabarBack0: UIView!
    @IBOutlet weak var tabContent: UIView!
    @IBOutlet weak var tabarBackWidth: NSLayoutConstraint!
    @IBOutlet weak var tabarScrollview: UIScrollView!
    @IBAction func next(_ sender: UIButton) {
        delegate.next(sender: self)
    }
    @IBAction func cancel(_ sender: UIButton) {
        delegate.cancel(sender: self)
    }

    var delegate: SelPartnerDelegate!
    
    
    
    
    
  
    
    
    
    
    
    let realm = try! Realm()
    var partners: Results<Partner>!
    
    var mortids: [Int]!
    
    func popPartner(){
        
        Alamofire.request("\(hj.url)appapi/partner/list/").responseJSON { response in
        
            if let JSON = response.result.value  as? [String: Any] {

                if let result = JSON["result"] as? [String:Any] {
                    if let err = result["error"] as! String?{
                        self.hj.showAlert(vc: self, msg: err); return
                    }
                    
                }
                
                
                let result = JSON["result"] as! [Any]
                try! self.realm.write {
                    self.realm.delete(self.realm.objects(Partner.self))
                    
                    result.map{
                        
                        let a = $0 as! [String : Any]
                        
                        let c = Partner()
                        c._id = a["_id"] as! Int
                        c.partner_name = a["partner_name"] as! String
                        c.branch = a["branch"] as! String
                        c.service_name = a["service_name"] as! String
                        c.manager_name = a["manager_name"] as! String
                        c.phone1 = a["phone1"] as! String
                        c.phone2 = a["phone2"] as! String
                        c.fax_num = a["fax_num"] as! String
                        c.sell_num = a["sell_num"] as! String
                        c.addr = a["addr"] as! String
                        c.email = a["email"] as! String
                        c.bank_id = a["bank_id"] as! String
                        c.bank_num = a["bank_num"] as! String
                        c.bank_name = a["bank_name"] as! String
                        c.code = a["code"] as! String
                        c.bcode = a["bcode"] as! String
                        c.x = a["x"] as! String
                        c.y = a["y"] as! String
                        c.bus = a["bus"] as! String
                        c.metro = a["metro"] as! String
                        c.last = a["last"] as! String
                        c.tab_name = a["tab_name"] as? String ?? ""
                        c.district_name = a["district_name"] as? String ?? ""
                        c.adm_single_code = a["adm_single_cd"] as? String ?? ""
                        
                        if c.last == "1" { self.realm.add(c, update: true) }
                        
                        
                        
                    } // end - map
                    
                } // end - realm.write
                
                self.partners = self.realm.objects(Partner.self)
                
                print("Partner count: \(self.partners.count)")
                
                self.makePartners()
                
                self.setupTabar()
            }
        }
    } // end - pop
    
    var districts = [String]()
    func makePartners(){
        
        //let arrDis = Array(partners!)
        
        // 키가 ref인 map 만들기
        //let refmap = arrDis.map{ [$0.ref: $0] }
        
        //dump(refmap)
        
        
        //Update
//        try! realm.write {
//            for dis in (partners.filter("ref = '0'")){
//                let predicate = NSPredicate(format: "ref = %@", dis.adm_single_cd)
//                dis.setValue(List(partners.filter(predicate)), forKey: "locals")
//                print("admcd=\(dis.adm_single_cd)  locals count=\(dis.locals.count)")
//            }
//        }
        
        //distinct
        let districts0 = Set(partners.value(forKey: "adm_single_code")  as! [String])
        districts = Array(districts0)
        
        
        //맵 확인
        //_ = Array( partners ).map{ print($0.locals.count) }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //make tab
    let tabar: UIView = UIView()
    var attrNorm: [String : Any] = [:]
    var attrSel: [String : Any] = [:]
    var tabs = [UIButton]()
    var items: [UITabBarItem]?
    var vcs: [SelPartnerTabViewController]?
    let tabarMarginTop: CGFloat = 55
    let tabarHeight: CGFloat = 34
    let hj = hjUtil()
    
    func setupTabar(){
        
        connectTabBar()
        
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
        let tabWidth = view.bounds.width / CGFloat(districts.count)
        let tabHeight = tabar.bounds.height
        
        
        for i in 0...districts.count-1 {
            let predicate = NSPredicate(format: "adm_single_code = %@", districts[i])
            let t = (realm.objects(Partner.self).filter(predicate))[0]
            
            
            var tab = UIButton()
            if i == 0 {
                tab = getTab(isFirst: true, isLast: false, title: t.tab_name, tag: 0)
                
            }
            else if i == districts.count - 1 { tab = getTab(isFirst: false, isLast: true, title: t.tab_name, tag: districts.count - 1) }
            else { tab = getTab(isFirst: false, isLast: false, title: t.tab_name, tag: i) }
            
            tab.frame = CGRect(x: tabWidth * CGFloat(i), y: 0, width: tabWidth, height: tabHeight)
            
            tabs.append(tab)
            
            self.tabar.addSubview(tab)
            
            
        }
        
        tabarBackWidth.constant = tabar.bounds.width
        
        
        
        onBtnClick( tabs[0] )
        
        tabarScrollview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
    }
    
    func addTabar(){
        
        tabar.translatesAutoresizingMaskIntoConstraints = false
        
        tabarBack.addSubview(tabar)
        
        //constraint
        NSLayoutConstraint(item: tabar, attribute: .leading, relatedBy: .equal, toItem: tabarBack, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: tabar, attribute: .top, relatedBy: .equal, toItem: tabarBack, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: tabar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: tabar.bounds.width).isActive = true
        NSLayoutConstraint(item: tabar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: tabar.bounds.height).isActive = true
        
        
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
    
    func onBtnClick(_ sender : UIButton)
    {
        _ = tabs.map{ $0.isSelected = false }
        
        
        sender.isSelected = true
        tabBar.selectedItem = items?[sender.tag]
        
        
//        tabarScrollview.setContentOffset(
//            CGPoint(x: sender.frame.origin.x, y: 0),
//            animated: true)
        
        print("tabBar selectedItem = \(items?[sender.tag])")
        
        var vc = vcs?[sender.tag]
        if vc == nil{
            vc = initVC(code: districts[sender.tag])
            
        }
        //tabContent.insertSubview((vc?.view)!, at: 0)
        tabContent.addSubview((vc?.view)!)
        constrainTabview(v: (vc?.view)!)
        
    }
    func constrainTabview(v: UIView){
        
        v.translatesAutoresizingMaskIntoConstraints = false
        
        //constraint
        NSLayoutConstraint(item: v, attribute: .leading, relatedBy: .equal, toItem: tabContent, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: v, attribute: .trailing, relatedBy: .equal, toItem: tabContent, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: v, attribute: .top, relatedBy: .equal, toItem: tabContent, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: v, attribute: .bottom, relatedBy: .equal, toItem: tabContent, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
    }
    func connectTabBar(){
        
        items = [UITabBarItem]()
        vcs = [SelPartnerTabViewController]()
        for i in 0...districts.count-1 {
            let predicate = NSPredicate(format: "adm_single_code = %@", districts[i])
            let tab = (realm.objects(Partner.self).filter(predicate))[0]
            let item = UITabBarItem(title: tab.tab_name, image: nil, tag: i)
            item.tag = i
            items?.append(item)
            let vc = initVC(code: districts[i] )
            vcs?.append(vc)
            
        }
        tabBar.items = items
        
        tabBar.isHidden = true
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // make a viewController
        var vc = vcs?[item.tag]
        if vc == nil{
            vc = initVC(code: districts[item.tag])
         
        }
        print("tabBar didSelect = \(item.tag)")
        tabarBack.insertSubview((vc?.view)!, at: 0)
    }
    
    func initVC(code: String) -> SelPartnerTabViewController{
        //return SelPartnerTabViewController(nibName: "SelPartnerTabViewController", bundle: nil)
        return SelPartnerTabViewController(cd: code, morts: mortids)
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.delegate = self
        
        print("선택한 Mort ids = \(mortids)")
        
        popPartner()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func instanceFromNib(nibName: String) -> UIView {
//        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
//    }

}
