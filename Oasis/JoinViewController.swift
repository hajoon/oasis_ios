//
//  JoinViewController.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 16..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit
import Alamofire
import DownPicker
import RealmSwift

class JoinViewController: UIViewController, CheckboxDelegate {
    @IBOutlet weak var email: TextfieldJoin!
    @IBOutlet weak var password: TextfieldJoin!
    @IBOutlet weak var rePass: TextfieldJoin!
    @IBOutlet weak var name: TextfieldJoin!
    @IBOutlet weak var bank: UITextField!
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var chkAll: Checkbox!
    @IBOutlet weak var chkService: Checkbox!
    @IBOutlet weak var chkPrivacy: Checkbox!
    @IBAction func tapBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    let segSubinfo = "subinfo"
    
    let hj = hjUtil()
    var banks: Results<Bank>?
    let realm = try! Realm()
    
    var bankPicker: DownPicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        hj.hideKeyboardWhenTappedAround(vc: self)
        
        //delegate
        chkAll.delegate = self
        chkService.delegate = self
        chkPrivacy.delegate = self
        
        //notice
        NotificationCenter.default.addObserver(self, selector: #selector(self.ButtonNoIconTouchUpInside), name: Notification.Name("ButtonNoIconTouchUpInside"), object: nil)
        
        //downpicker connect
        banks = realm.objects(Bank.self)
        var banknames = [Any]()
        let arrBanks = Array(banks!)
        arrBanks.map{ banknames.append($0.name) }
        bankPicker = DownPicker(textField: bank, withData: banknames)
        
        
    }
    func ButtonNoIconTouchUpInside(notification: Notification){
        
        presentSubInfo()
      
    }
    
    func onCheck(sender: Checkbox) {
        
        let tag = sender.iTag
        print("check\(tag) ison = \(sender.checked)")
        if tag == 0{ // 전체동의
            checkAll()
        }else if tag == 1{ // 서비스
            checkAllChecked()
        }else if tag == 2{ // 개인정보
            checkAllChecked()
        }
    }
    
    func presentSubInfo(){
        
        guard validate() else { return }
        
        performSegue(withIdentifier: segSubinfo, sender: self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == segSubinfo else { return }
        
        let navVC = segue.destination as? UINavigationController
        
        let vc = navVC?.viewControllers.first as! SubInfoViewController
        
        vc.param = getParam()
        
    }
    
    //체크박스 체크
    func checkAll(){
        if chkAll.checked! {
            chkPrivacy.isChecked = true
            chkService.isChecked = true
        }else{
            chkPrivacy.isChecked = false
            chkService.isChecked = false
        }
    }
    func checkAllChecked(){
        
        if chkPrivacy.checked! && chkService.checked! { try! chkAll.isChecked = true }
        else { chkAll.isChecked = false }
    }

    
    
    
    func validate() -> Bool{
        
        guard
            email.textField.text != ""
                && password.textField.text != ""
                && name.textField.text != ""
            else {
                showAlert(msg: "필수항목 입력바랍니다")
                return false
        }
        
        guard password.textField.text == rePass.textField.text else{
            showAlert(msg: "패스워드가 확인 바랍니다")
            return false
        }
        
        guard chkAll.checked!
            && chkService.checked!
            && chkPrivacy.checked!
            else {
                showAlert(msg: "동의 체크 바랍니다")
                return false
                
        }
        
        return true
        
    }
    
    func getParam() -> [String:Any]{
        
        //현재 약관 정보
        let manage1 = realm.objects(Managing.self).filter("manage_id = '1'")
        let manage2 = realm.objects(Managing.self).filter("manage_id = '2'")
        let manage9 = realm.objects(Managing.self).filter("manage_id = '9'")
        
        //선택한 은행 정보
        guard let selectedBank = banks?[bankPicker.selectedIndex] else {return [:]}
        
        let param = [
            "email": email.textField.text ?? "",
            "password": password.textField.text ?? "",
            "name": name.textField.text ?? "",
            "bank_id": selectedBank._id,
            "bank_name": selectedBank.name,
            "account": account.text ?? "",
            "manage_1": manage1.first!._id,
            "manage_2": manage2.first!._id,
            "manage_9": manage9.first!._id,
            "app": "1",
            "mobile": "",
            "post_code": "",
            "addr": "",
            "addr_detail": "",
            "token": "no token yet in ios. soon will come...",
            "adn_cd": ""
        ] as [String : Any]
        
        return param
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
    
    
    
        
    
    

}
