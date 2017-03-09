//
//  MortNavigationController.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 26..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

class MortNavigationController: UINavigationController {

    var cover: UIView!
    var pop: UIView!
    var vc: UIViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        navigationBar.layer.zPosition = -1
//        navigationBar.isUserInteractionEnabled = false
        
//        cover = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
//        cover.backgroundColor = UIColor.black
//        cover.alpha = 0.5
//        view.addSubview(cover)
//        cover.isHidden = true
        
//        pop = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
//        pop.backgroundColor = UIColor.white
//        view.addSubview(pop)
//        pop.isHidden = true

//        vc = storyboard?.instantiateViewController(withIdentifier: "SelPartnerViewController")
//        addChildViewController(vc)
//        vc.view.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
//        view.addSubview(vc.view)
//        vc.view.isHidden = true
//        vc.beginAppearanceTransition(true, animated: true)
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
