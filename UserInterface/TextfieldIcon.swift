//
//  TextfieldIcon.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 16..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

class TextfieldIcon: UIView {

    @IBOutlet weak var back: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var bottomLine: UIView!
    

    
    @IBInspectable var placeholderText: String = "" {
        didSet {
            
            textfield.placeholder = placeholderText
            
        }
    }
    
    @IBInspectable var iconName: String = "ic_email_normal" {
        didSet {
            icon.image = UIImage(named: iconName)
            
        }
    }
    
    @IBInspectable var bottomLineColor: UIColor? {
        didSet {
            bottomLine.backgroundColor = bottomLineColor
        }
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
        let nib = UINib(nibName: "TextfieldIcon", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    

    
}
