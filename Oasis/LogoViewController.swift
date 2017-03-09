//
//  LogoViewController.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 3..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class LogoViewController: UIViewController {

    let hj = hjUtil()
    let realm = try! Realm()
    //var cates: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        popBank()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentLogin(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    func presentMain(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Drawer", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Drawer")
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    func autoLogin(){
        let mems = realm.objects(Member.self)
        if mems.count == 0 {
            self.presentLogin();return
        }
        let me = mems[0]
        
        let param: Parameters = [
            "_id": me._id,
            "password": me.password,
            "token": me.token,
            "id": me.id
        ]
        
        
        Alamofire.request("\(hj.url)app/api/member/login/auto", method: .post, parameters: param).responseJSON { response in
            print(response.result)   // result of response serialization
            print(response.error ?? "")
            if let JSON = response.result.value  as? [String: Any] {
                let result = JSON["result"] as! [String:Any]
                if let err = result["error"] as! String?{ self.presentLogin();return }
                
                //멤버정보 갱신
                try! self.realm.write {
                    
                    let c = Member()
                    let a = result
                    
                    c._id = Int(a["_id"] as! String)!
                    c.id = a["id"] as! String? ?? ""
                    c.mobile = a["mobile"] as! String? ?? ""
                    c.manage_9 = a["manage_9"] as! String? ?? ""
                    c.manage_2 = a["manage_2"] as! String? ?? ""
                    c.account = a["account"] as! String? ?? ""
                    c.manage_1 = a["manage_1"] as! String? ?? ""
                    c.app = a["app"] as! String? ?? ""
                    c.bank_id = a["bank_id"] as! String? ?? ""
                    c.email = a["email"] as! String? ?? ""
                    c.name = a["name"] as! String? ?? ""
                    c.password = a["password"] as! String? ?? ""
                    c.bank_name = a["bank_name"] as! String? ?? ""
                    c.token = a["token"] as! String? ?? ""
                    c.state = a["state"] as! String? ?? ""
                    c.cert_kakao_id = a["kakao_id"] as! String? ?? ""
                    c.cert_naver_id = a["naver_id"] as! String? ?? ""
                    c.cert_google_id = a["google_id"] as! String? ?? ""
                    c.postnum = a["post_code"] as! String? ?? ""
                    c.address = a["addr"] as! String? ?? ""
                    c.address2 = a["addr_detail"] as! String? ?? ""
                    c.addr_cd = a["adm_cd"] as! String? ?? ""
                    
                    self.realm.add(c, update:true)
                    
                } // end - realm.write
                
                let rslt = self.realm.objects(Member.self)[0]
                
                print("Member = \(rslt)")
                
                self.presentMain()
                
            } // end - response
        } // end - Alamofire
        
    }
    
    
    func popBank(){
        Alamofire.request("\(hj.url)appapi/banks").responseJSON { response in
            if let JSON = response.result.value  as? [String: Any] {
                let result = JSON["result"] as! [Any]
                
                try! self.realm.write {
                    self.realm.delete(self.realm.objects(Bank.self))
                    
                    result.map{
                        
                        let a = $0 as! [String : Any]
                        
                        var c = Bank()
                        c._id = a["_id"] as! Int
                        c.name = a["name"] as! String
                        
                        self.realm.add(c)
                        
                    } // end - map
                    
                } // end - realm.write
                
                let rslt = self.realm.objects(Bank.self)
                
                print("Bank count: \(rslt.count)")
                
                self.popTerms()
                
            }
        }
    } // end - pop
    
    func popTerms(){
        let param: Parameters = ["a": "1,2,9"]
        Alamofire.request("\(hj.url)appapi/managing/latestone", parameters: param).responseJSON { response in
            if let JSON = response.result.value  as? [String: Any] {
                let result = JSON["result"] as! [Any]
                
                try! self.realm.write {
                    self.realm.delete(self.realm.objects(Managing.self))
                    
                    result.map{
                        
                        let a = $0 as! [String : Any]
                        
                        let c = Managing()
                        c._id = a["_id"] as! Int
                        c.manage_id = a["manage_id"] as! String
                        c.title = a["title"] as! String
                        c.content = a["content"] as! String
                        
                        self.realm.add(c)
                        
                    } // end - map
                } // end - realm.write
                
                let rslt = self.realm.objects(Managing.self)
                
                print("Managing count: \(rslt.count)")
                
                
                self.autoLogin()
            }
        }
    } // end - pop

    
    
    
}
