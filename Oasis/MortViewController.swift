//
//  MortViewController.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 16..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

protocol MortViewControllerDelegate {
    func mortsResponse()
}

class MortViewController: UITabBarController {
    
    @IBAction func tapBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    var dele: MortViewControllerDelegate!
    
    let tabar: UIView = UIView()
    var tab1 = UIButton()
    var tab2 = UIButton()
    var tab3 = UIButton()
    
    var attrNorm: [String : Any] = [:]
    var attrSel: [String : Any] = [:]
    let hj = hjUtil()
    func setupTabar(){
        
        self.tabBar.isHidden = true
        
//        for fontfamily in UIFont.familyNames{
//            for fontname in UIFont.fontNames(forFamilyName: fontfamily){
//                print(fontname)
//            }
//        }
        
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
        
        
        
        
        
        tabar.frame = CGRect(x: 0, y: 45, width: self.view.bounds.width, height: 35)
        
        addTabar()
        addBottomLine()
        
        //add tab
        
        tab1 = getTab(isFirst: true, isLast: false, title: "대출가능", tag: 0)
        tab2 = getTab(isFirst: false, isLast: false, title: "대출불가", tag: 1)
        tab3 = getTab(isFirst: false, isLast: true, title: "감정중", tag: 2)
        
        let tabWidth = view.bounds.width/3
        let tabHeight = tabar.bounds.height
        tab1.frame = CGRect(x: 0, y: 0, width: tabWidth, height: tabHeight)
        tab2.frame = CGRect(x: tabWidth, y: 0, width: tabWidth, height: tabHeight)
        tab3.frame = CGRect(x: tabWidth * 2, y: 0, width: tabWidth, height: tabHeight)
        
        
        self.tabar.addSubview(tab1)
        self.tabar.addSubview(tab2)
        self.tabar.addSubview(tab3)
        
        onBtnClick(tab1)
    }
    
    func addTabar(){
        
        tabar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tabar)
        
        //constraint
        NSLayoutConstraint(item: tabar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: tabar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        // uncheck under the bar
        NSLayoutConstraint(item: tabar, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: tabar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35).isActive = true
        
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
        
        
        self.tab1.isSelected = false
        self.tab2.isSelected = false
        self.tab3.isSelected = false
        
        sender.isSelected = true
        
        self.selectedIndex = sender.tag
    }
    
    
    
    
    
    
    
    
    
    
    let realm = try! Realm()
    var morts: Results<Mort>!
    
    func popMorts(result: Int){
        let me = realm.objects(Member.self)[0]
        Alamofire.request("\(hj.url)app/api/estm/paging/\(me._id)/\(result)/1/30/").responseJSON { response in
            if let JSON = response.result.value  as? [String: Any] {
                let result = JSON["result"] as! [String:Any]
                if let err = result["error"] as! String?{ self.hj.showAlert(vc: self, msg: err); return }
                
                let rslts = result["results"] as! [[String:Any]]
                try! self.realm.write {
                    //self.realm.delete(self.realm.objects(Mort.self))
                    rslts.map{
                        
                        let a = $0
                        
                        let c = Mort()
                        c._id = Int( a["estm_id"] as! String )!
                        c.category_id = a["category_id"] as! String
                        c.brand = a["brand_name"] as! String
                        c.member_id = a["member_id"] as! String
                        c.loan_id = a["loan_id"] as! String
                        c.title = a["title"] as! String
                        c.buy_date = a["buy_date"] as! String
                        c.buy_price = a["buy_price"] as! String
                        c.buy_route = a["buy_path"] as! String
                        c.memo = a["memo"] as! String
                        c.flag_state = a["state"] as! String
                        c.reg_date = a["reg_date"] as! String
                        c.date_update = String( a["order_by_date"] as! Int)
                        c.flag_result = a["flag_result"] as! String
                        c.cnt_addimage = a["img_count"] as! String
                        c.is_reloan = a["is_reloan"] as! String
                        c.appraise_id = a["appraise_id"] as? String ?? ""
                        c.appraise_date = a["appraise_date"] as? String ?? ""
                        c.appraise_amount = a["appraise_amount"] as? String ?? ""
                        c.rate = a["rate"] as? String ?? ""
                        c.partner_id = a["partner_id"] as? String ?? ""
                        c.admin_id = a["admin_id"] as? String ?? ""
                        c.history = a["history"] as? String ?? ""
                        c.is_permission = a["is_permission"] as? String ?? ""
                        
                        
                        self.realm.add(c, update: true)
                        
                    } // end - map
                    
                } // end - realm.write
                
                self.morts = self.realm.objects(Mort.self)
                
                print("Mort count: \(self.morts?.count)")
                
                self.dele.mortsResponse()
                
            }
        }
    } // end - pop
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTabar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
