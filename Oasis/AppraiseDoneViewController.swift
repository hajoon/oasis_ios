//
//  AppraiseDoneViewController.swift
//  Oasis
//
//  Created by mac on 2017. 2. 14..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

class AppraiseDoneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            self.presentMain()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func presentMain(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Drawer", bundle: nil)
        let vc : UIViewController! = storyboard.instantiateViewController(withIdentifier: "Drawer")
        
        self.present(vc, animated: true, completion: nil)
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
