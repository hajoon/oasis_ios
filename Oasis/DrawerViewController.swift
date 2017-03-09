//
//  DrawerViewController.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 13..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.CircleImageViewTap), name: Notification.Name("CircleImageViewTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.DrawerItemTap), name: Notification.Name("DrawerItemTap"), object: nil)
    }
    func CircleImageViewTap(notification: Notification){
        print("CircleImageViewTap!")
        presentProfile()
        
    }
    func DrawerItemTap(notification: Notification){
        
        let me = notification.object as! UIView
        if me.tag == 0{ // 견적조회
            presentMort()
        }else if me.tag == 1{ // 대출조회
            presentLoan()
        }else if me.tag == 2{ // 디오아시스
            
        }else{ // 설정
            presentSetting()
        }
        
    }
    
    func presentSetting(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc : UIViewController! = storyboard.instantiateViewController(withIdentifier: "SettingNavigationController")
        
        self.present(vc, animated: true, completion: nil)
    }
    func presentLoan(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Loan", bundle: nil)
        let vc : UIViewController! = storyboard.instantiateViewController(withIdentifier: "LoanlistNavController")
        
        self.present(vc, animated: true, completion: nil)
    }
    func presentMort(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Mort", bundle: nil)
        let vc : UIViewController! = storyboard.instantiateViewController(withIdentifier: "MortNavViewController")
        
        self.present(vc, animated: true, completion: nil)
    }
    func presentProfile(){
        
        let vc : UIViewController! = self.storyboard!.instantiateViewController(withIdentifier: "ProfileNavViewController")
        
        self.present(vc, animated: true, completion: nil)
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
