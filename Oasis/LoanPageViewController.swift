//
//  LoanPageViewController.swift
//  Oasis
//
//  Created by mac on 2017. 1. 31..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

protocol LoanPageViewControllerDelegate: class {
    func selectedPage(curIndex: Int)
    func popListDone()
}

class LoanPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let hj = hjUtil()
    let realm = try! Realm()
    
    var vc0: LoanlistViewController!
    //var currentIndex: Int!
    var cntrls = [LoanlistXViewController]()
    
    var dele: LoanPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        vc0 = storyboard!.instantiateViewController(withIdentifier: "LoanlistViewController") as? LoanlistViewController
        
        for i in 0...vc0.tabname.count-1{
            let vc = loanListXController(i)!
            vc.view.tag = i
            cntrls.append(vc)
            
        }
        
        dataSource = self
        delegate = self
        
    }
 
    
    
    func loanListXController(_ index: Int) -> LoanlistXViewController? {
        
        guard let storyboard = storyboard else {return nil}
        
        if index == 0{
            if let page = storyboard.instantiateViewController(withIdentifier: "Loanlist0ViewController") as? Loanlist0ViewController {
              
                page.idx = index
              
                return page
            }
        }else{
            if let page = storyboard.instantiateViewController(withIdentifier: "Loanlist1ViewController") as? Loanlist1ViewController {
                
                page.idx = index
                
                return page
            }
        }
        
        return nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //dataSource
    // 1
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? LoanlistXViewController {
            let index = viewController.idx
            guard index != NSNotFound && index != 0 else { return nil }
            let prevIndex = index! - 1
            let lastIndex = cntrls.count - 1
            guard prevIndex >= 0 else { return cntrls[lastIndex] }
            guard lastIndex + 1 > prevIndex else { return nil }
            return cntrls[prevIndex]
        }
        return nil
    }
    
    // 2
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
       
        if let viewController = viewController as? LoanlistXViewController {
            let index = viewController.idx
            guard index != NSNotFound else { return nil }
            let nextIndex = index! + 1
            let count = cntrls.count
            guard count != nextIndex else { return cntrls[0] }
            guard count > nextIndex else {return nil}
            return cntrls[nextIndex]
        }
        return nil
    }
    
//    // MARK: UIPageControl
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        // 1
//        return cntrls.count
//    }
//    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        // 2
//        
//        return currentIndex ?? 0
//    }
    
    
    //delegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let curidx =  pageViewController.viewControllers!.first!.view.tag
        
        dele?.selectedPage(curIndex: curidx)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func popLoanlist(state: String){
        
        let me = realm.objects(Member.self)[0]
        
        Alamofire.request("\(hj.url)app/api/loan/paging/\(me._id)/\(state)/1/30/").responseJSON { response in
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
                let common = rslt["common"] as! [String:Any]
                let results = rslt["results"] as! [[String:Any]]
                
                try! self.realm.write {
                    //self.realm.delete(self.realm.objects(Member.self))
                    
                    results.map{
                        
                        let c = Loan()
                        let a = $0
                        
                        c._id = Int(a["loan_id"] as! String)!
                        c.member_id = a["member_id"] as? String ?? ""
                        c.date_visit_json = a["date_visit_json"] as? String ?? ""
                        c.date_in = a["date_in"] as? String ?? ""
                        c.partner_id = a["partner_id"] as? String ?? ""
                        c.admin_id = a["admin_id"] as? String ?? ""
                        c.start_date = a["start_date"] as? String ?? ""
                        c.pay_date = a["pay_date"] as? String ?? ""
                        c.end_date = a["end_date"] as? String ?? ""
                        c.overdue_start = a["overdue_start"] as? String ?? ""
                        c.rate = a["rate"] as? String ?? ""
                        c.amount = a["amount"] as? String ?? ""
                        c.nopay = a["nopay"] as? String ?? ""
                        c.inter_daily = a["day_interest"] as? String ?? ""
                        c.flag_state = a["state"] as? String ?? ""
                        c.flag_reg = a["reg_method"] as? String ?? ""
                        c.partner_name = a["partner_name"] as? String ?? ""
                        c.addr = a["addr"] as? String ?? ""
                        c.x = a["x"] as? String ?? ""
                        c.y = a["y"] as? String ?? ""
                        c.bus = a["bus"] as? String ?? ""
                        c.metro = a["metro"] as? String ?? ""
                        c.estm_id = a["estm_id"] as? String ?? ""
                        c.title = a["title"] as? String ?? ""
                        c.cnt_addimage = a["cnt_addimage"] as? String ?? ""
                        c.item_count = a["item_count"] as? String ?? ""
                        c.auction_no = a["auction_no"] as? String ?? ""
                        c.auction_start = a["auction_start"] as? String ?? ""
                        c.auction_end = a["auction_end"] as? String ?? ""
                        c.auction_price = a["auction_price"] as? String ?? ""
                        c.auction_cancel = a["auction_cancel"] as? String ?? ""
                        c.repay_amount = a["repay_amount"] as? String ?? ""
                        
                        self.realm.add(c, update: true)
                        
                    }
                    
                    
                    
                } // end - realm.write
                
                
                
                let rs = self.realm.objects(Loan.self)
                
                print("Loan count = \(rs.count)")
                
                self.dele?.popListDone()
                
            } // end - response
        } // end - Alamofire
        
        
    }
    
    
    
}
