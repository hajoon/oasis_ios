//
//  LoginViewController.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 3..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift


class LoginViewController: UIViewController {
    @IBOutlet weak var email: TextfieldLogin!
    @IBOutlet weak var password: TextfieldLogin!
    @IBOutlet weak var login: ButtonLogin!

    @IBAction func touchUpInside(_ sender: UIButton) {
        
    }
    
    //exception message
    let invalid_access = "invalid_access"
    let invalid_signup = "invalid_signup"
    let already_signup = "invalid_signup"
    let not_signup = "not_signup"
    let not_singnin = "not_singnin"
    let invalid_signin = "invalid_signin"
    let invalid_token = "invalid_token"
    let not_authorized = "not_authorized"
    let server_exception = "server_exception"
    let unexpected = "unexpected"
    let unexpected_exception_occured = "unexpected exception occured"
    
    
    let hj = hjUtil()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.ButtonLoginTouchUpInside), name: Notification.Name("ButtonLoginTouchUpInside"), object: nil)
    }
    
    func ButtonLoginTouchUpInside(notification: Notification){
      
        let me = notification.object as! ButtonLogin
        print("ButtonLoginTouchUpInside tig = \( me.tig )")

        send()
    }
    
    
    func presentMain(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Drawer", bundle: nil)
        let vc : UIViewController! = storyboard.instantiateViewController(withIdentifier: "Drawer")
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func borderBottom( _ textFieldLogin: TextfieldLogin,  _ color: CGColor){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color
        border.frame = CGRect(x: 0, y: textFieldLogin.frame.size.height - width, width:  textFieldLogin.frame.size.width, height: textFieldLogin.frame.size.height)
        
        border.borderWidth = width
        textFieldLogin.layer.addSublayer(border)
        textFieldLogin.layer.masksToBounds = true
    }

    
    
    
    func validate() -> Bool{
        
        guard email.textField.text != "" else {
            showAlert(msg: "이메일 입력바랍니다")
            return false
        }
        guard password.textField.text != "" else{
            showAlert(msg: "비밀번호 입력바랍니다")
            return false
        }
        
        
        return true
        
    }
    // Alert
    func showAlert( msg: String ) {
        
        let alertController = UIAlertController(title: msg, message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func send(){
        guard validate() else { return }
        
        
        let param: Parameters = [
            "password": password.textField.text ?? "",
            "token": "no token yet in ios. soon will come...",
            "email": email.textField.text ?? ""
        ]
        
        
        Alamofire.request("\(hj.url)app/api/member/login", method: .post, parameters: param).responseJSON { response in
            print(response.result)   // result of response serialization
            print(response.error ?? "")
            if let JSON = response.result.value  as? [String: Any] {
                let result = JSON["result"] as! [String:Any]
                if let err = result["error"] as! String?{
                    
                    self.showAlert(msg: err)
                    
                    return
                }
                
                
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
                    
                    self.realm.create(Member.self, value: c, update: true)
                    
                } // end - realm.write
                
                let rslt = self.realm.objects(Member.self)[0]
                
                print("Member = \(rslt)")
                
                self.presentMain()
                
            } // end - response
        } // end - Alamofire
        
        
    }
    

}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
