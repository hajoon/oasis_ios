//
//  SettingViewController.swift
//  Oasis
//
//  Created by mac on 2017. 2. 3..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit
import RealmSwift

class SettingViewController: UIViewController {
    @IBOutlet weak var acount: UIView!
    @IBOutlet weak var alarm: UIView!
    @IBOutlet weak var notice: UIView!
    @IBOutlet weak var faq: UIView!
    @IBOutlet weak var policy: UIView!
    @IBOutlet weak var logout: UIView!

    @IBAction func prev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer(target: self, action: #selector(someAction(_:)))
        acount.addGestureRecognizer(gesture)
        alarm.addGestureRecognizer(gesture)
        notice.addGestureRecognizer(gesture)
        faq.addGestureRecognizer(gesture)
        policy.addGestureRecognizer(gesture)
        logout.addGestureRecognizer(gesture)
        
        
    }
    
    
    func someAction(_ sender:UITapGestureRecognizer){
        
        let tag: Int = (sender.view?.tag)!
        switch tag {
        case 5: // logout
            showLogoutOK(msg: "로그아웃 하시겠습니까?")
        
            break;
        default:
            break;
        }
        
        
    }
    // Alert
    func showLogoutOK( msg: String ) {
        
        let alertController = UIAlertController(title: msg, message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
            try! self.realm.write { self.realm.delete(self.realm.objects(Member.self)) }
            self.presentLogin()
            
        }
        let nokAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(nokAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func presentLogin(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
}
