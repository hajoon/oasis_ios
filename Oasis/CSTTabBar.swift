//
//  CSTTabBar.swift
//  CustomTabbar
//
//  Created by jhkim on 2015. 6. 23..
//  Copyright (c) 2015년 hwi. All rights reserved.
//

import UIKit

class CSTTabBar: UITabBarController
{
    let customTabBarView = UIView()
    let tabBtn01 = UIButton()
    let tabBtn02 = UIButton()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        
        customTabBarView.frame = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 60)
        customTabBarView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        
        let widthOfOneBtn = self.tabBar.frame.size.width/2
        let heightOfOneBtn = self.customTabBarView.frame.height
        
        
        
        tabBtn01.frame = CGRect(x: 0, y: 0, width: widthOfOneBtn, height: heightOfOneBtn)
        tabBtn02.frame = CGRect(x: widthOfOneBtn, y: 0, width: widthOfOneBtn, height: heightOfOneBtn)
        
        tabBtn01.setTitle("첫번째 버튼", for: UIControlState())
        tabBtn02.setTitle("두번째 버튼", for: UIControlState())
        
        tabBtn01.tag = 0
        tabBtn02.tag = 1
        
        setAttributeTabBarButton(tabBtn01)
        setAttributeTabBarButton(tabBtn02)
        

        
        self.view.addSubview(customTabBarView)
    }
    
    func setAttributeTabBarButton(_ btn : UIButton)
    {
        btn.addTarget(self, action: #selector(CSTTabBar.onBtnClick(_:)), for: UIControlEvents.touchUpInside)
        btn.setTitleColor(UIColor(red: 0.5, green: 0.5, blue: 0, alpha: 1), for: UIControlState())
        btn.setTitleColor(UIColor(red: 1, green: 1, blue: 0, alpha: 1), for: UIControlState.selected)
        self.customTabBarView.addSubview(btn)
    }
    
    func onBtnClick(_ sender : UIButton)
    {
        self.tabBtn01.isSelected = false
        self.tabBtn02.isSelected = false
        
        sender.isSelected = true
        
        self.selectedIndex = sender.tag
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
