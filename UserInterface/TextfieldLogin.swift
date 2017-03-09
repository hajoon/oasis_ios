//
//  TextfieldLogin.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 4..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit



//@IBDesignable
class TextfieldLogin: UIView {
    @IBOutlet weak var bottomLine: UIView!
    @IBAction func editingDidEnd(_ sender: UITextField) {
        setState(isEdit: false)
    }
    
    @IBOutlet weak var textField: UITextField!

    @IBAction func editingDidBegin(_ sender: UITextField) {
        //print("editingDidBegin!")
        setState(isEdit: true)
        
    }
    @IBInspectable var isSecure: Bool = false {
        didSet {
            
            textField.isSecureTextEntry = isSecure
            
        }
    }
    @IBInspectable var placeholderText: String = "" {
        didSet {
            textField.placeholder = placeholderText
        }
    }
   
    let hj = hjUtil()
    
    // Our custom view from the XIB file
    var view: UIView!
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        setState(isEdit: false)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TextfieldLogin", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    
    func setState(isEdit: Bool){
        
        if (isEdit){
            //borderBottom( hjUtil.rgb(0x0033a0).cgColor )
            setBottomLineColor(color: hj.rgb(0x0033a0))
        }else{
            //borderBottom( hjUtil.rgb(0x000000).cgColor )
            setBottomLineColor(color: hj.rgb(0x000000))
        }
        
    }
    
    func setBottomLineColor(color: UIColor){
        bottomLine.backgroundColor = color
    }
    
    func borderBottom(_ color: CGColor){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }

}


   
