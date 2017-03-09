//
//  ProfileViewController.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 16..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBAction func tapBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.ButtonNoIconTouchUpInside), name: Notification.Name("ButtonNoIconTouchUpInside"), object: nil)
    }
    func ButtonNoIconTouchUpInside(notification: Notification){
        //수정완료
        let me = (notification.object as! ButtonNoIcon).view!
        if me.tag == 0{ // 우편번호
            
        }else if me.tag == 1{ // 수정완료
            dismiss(animated: true, completion: nil)
        }
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
