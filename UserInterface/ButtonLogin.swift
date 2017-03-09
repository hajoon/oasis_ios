//
//  ButtonLogin.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 5..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

//@IBDesignable
class ButtonLogin: UIView {
    @IBOutlet weak var button: UIButton!

    @IBInspectable var tig: Int = 0 {
        didSet {
            view.tag = tig
        }
    }
    @IBInspectable var title: String = "" {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }
    @IBAction func touchUpInside(_ sender: UIButton) {
        print("ButtonLogin touchUpInside!")
        NotificationCenter.default.post(name: Notification.Name("ButtonLoginTouchUpInside"), object: self)
        
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
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ButtonLogin", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    
}
