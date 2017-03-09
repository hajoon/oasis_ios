//
//  DrawerItem.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 10..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

//@IBDesignable
class DrawerItem: UIView {
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var text: UILabel!

    
    @IBInspectable var iconName: String = "ic_drawer_estimate" {
        didSet {
            
            icon.image = UIImage(named: iconName)
        }
    }
    
    @IBInspectable var name: String = "견적조회" {
        didSet {
            text.text = name
        }
    }
    
    @IBInspectable var isArrowVisible: Bool = true {
        didSet {
            arrow.isHidden = isArrowVisible
        }
    }
    
    @IBInspectable var tagInt: Int = 0 {
        didSet {
            view.tag = tagInt
        }
    }
    
    func setupUI(){
        
        // 3. add action to myView
        let gesture = UITapGestureRecognizer(target: self, action: #selector(someAction(_:)))

        self.back.addGestureRecognizer(gesture)
        
        
        
    }
    
    func someAction(_ sender:UITapGestureRecognizer){
        // do other task
        NotificationCenter.default.post(name: Notification.Name("DrawerItemTap"), object: view)
    }
    
    
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        setupUI()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DrawerItem", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

}
