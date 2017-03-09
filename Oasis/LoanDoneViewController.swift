//
//  LoanDoneViewController.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 17..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

class LoanDoneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            self.presentMort()
            
        }
        
    }
    func presentMort(){
        let vc : UIViewController! = self.storyboard!.instantiateViewController(withIdentifier: "MortNavViewController")
        
        
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
