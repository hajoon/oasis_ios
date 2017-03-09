//
//  SubInfoViewController.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 16..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class SubInfoViewController: UIViewController {

    @IBOutlet weak var inputPhone: TextfieldIcon!
    @IBAction func tapBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    var param = [String:Any]()
    
    let hj = hjUtil()
    var me: Result<Member>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hj.hideKeyboardWhenTappedAround(vc: self)
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.ButtonNoIconTouchUpInside), name: Notification.Name("ButtonNoIconTouchUpInside"), object: nil)
        
        print("param.count = \(param.count)")
        
    }

    func ButtonNoIconTouchUpInside(notification: Notification){
        
        send()
        
    }

    func presentLogin(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func validate() -> Bool{
        guard inputPhone.textfield.text != "" else { showAlert(); return false }
        return true
    }
    
    func send(){
        guard validate() else {
            return
        }
        
        param["mobile"] = inputPhone.textfield.text
        
        let jsonstring = hj.jsonToString(json: param as AnyObject)
        let parameters: Parameters = ["json_data": jsonstring ]

        Alamofire.request("\(hj.url)app/api/member/signup", method: .post, parameters: parameters).responseJSON { response in
            print(response.result)   // result of response serialization
            print(response.error ?? "")
            if let JSON = response.result.value  as? [String: Any] {
                let result = JSON["result"] as! [String:Any]
                
                //멤버정보 저장
                try! self.realm.write {
                    self.realm.delete(self.realm.objects(Member.self))
                    let c = Member()
                    let a = result
                    
                    c._id = Int(a["_id"] as! String)!
                    c.mobile = a["mobile"] as! String
                    c.manage_9 = a["manage_9"] as! String
                    c.manage_2 = a["manage_2"] as! String
                    c.account = a["manage_2"] as! String
                    c.manage_1 = a["manage_1"] as! String
                    c.app = a["app"] as! String
                    c.bank_id = a["bank_id"] as! String
                    c.email = a["email"] as! String
                    c.name = a["name"] as! String
                    c.password = a["password"] as! String
                    c.bank_name = a["bank_name"] as! String
                    
                    self.realm.add(c)
                    
                } // end - realm.write



                let rslt = self.realm.objects(Member.self)[0]
                
                print("Member = \(rslt)")

                self.presentLogin()
                
            } // end - response
        } // end - Alamofire
        
        
    }
    
    
    
    
    // Alert
    func showAlert() {
        
        let alertController = UIAlertController(title: "필수항목 입력 바랍니다", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    

}
