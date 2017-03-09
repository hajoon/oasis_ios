//
//  ButtonNoIcon.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 9..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import Foundation
import UIKit

protocol ButtonNoIconDelegate: class {
    func touchUpInside(sender: ButtonNoIcon)
}

//@IBDesignable
class ButtonNoIcon: UIView{
    
    var delegate: ButtonNoIconDelegate?
    
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func touchUpInside(_ sender: UIButton) {
        delegate?.touchUpInside(sender: self)
        NotificationCenter.default.post(name: Notification.Name("ButtonNoIconTouchUpInside"), object: self)
    }
    
    @IBInspectable var titleText: String = "" {
        didSet {
            button.setTitle(titleText, for: .normal)
            
        }
    }
    @IBInspectable var tagInt: Int = 0 {
        didSet {
            view.tag = tagInt
        }
    }
    
    @IBInspectable var titleTextColor: UIColor? {
        didSet {
            button.setTitleColor(titleTextColor, for: .normal)
        }
    }
    
    @IBInspectable var backgroundButtonColor: UIColor? {
        didSet {
            button.backgroundColor = backgroundButtonColor
        }
    }
    @IBInspectable var colorBorder: UIColor? = UIColor.black {
        didSet {
            button.layer.borderColor = colorBorder?.cgColor
        }
    }
    
    func initButton(){
        
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        
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
        initButton()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ButtonNoIcon", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
}
