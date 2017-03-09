//
//  ChangPWViewController.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 17..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

class ChangPWViewController: UIViewController {
    @IBAction func tapBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.ButtonNoIconTouchUpInside), name: Notification.Name("ButtonNoIconTouchUpInside"), object: nil)
        
    }
    func ButtonNoIconTouchUpInside(notification: Notification){
        
        dismiss(animated: true, completion: nil)
        
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
