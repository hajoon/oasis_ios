//
//  LoanNavigationViewController.swift
//  Oasis
//
//  Created by mac on 2017. 2. 16..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

protocol LoanNavigationControllerDelegate {
    func navPrepare(or segue: UIStoryboardSegue, sender: Any?)
}

class LoanNavigationViewController: UINavigationController {

    let segueToDetail = "navigationToLoandetail"
    var dele: LoanNavigationControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dele.navPrepare(or: segue, sender: sender)
    }
    
}
