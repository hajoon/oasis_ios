//
//  LoanDetailViewController.swift
//  Oasis
//
//  Created by mac on 2017. 2. 16..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

class LoanDetailViewController: UIViewController {
    @IBOutlet weak var back: UIView!

    var cur = 0 // 0: 대출신청, 1: 대출정상정보, 2: 경매대기, 3: 경매진행, 4: 상환
    var loanid = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        print("cur = \(cur) loan id = \(loanid)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
