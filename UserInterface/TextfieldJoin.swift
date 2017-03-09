//
//  TextfieldJoin.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 9..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

//@IBDesignable
class TextfieldJoin: UIView{
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var bottomLine: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBAction func editingDidBegin(_ sender: UITextField) {
        setState(curStyle!, true)
    }
    
    let hj = hjUtil()
    
    var curStyle: Int?
    
    @IBInspectable var style: Int = 1 {
        didSet {
            curStyle = style
            setState(style, false)
        }
    }
    @IBInspectable var isSecure: Bool = false {
        didSet {

            textField.isSecureTextEntry = isSecure
            
        }
    }
    
    
    func setState( _ style: Int, _ isEdit: Bool){
        
        var iconEmail: UIImage?
        var iconPassword: UIImage?
        var iconPasswordRe: UIImage?
        var iconName: UIImage?
        
        if(isEdit){
            iconEmail = UIImage(named: "ic_email_pressed")
            iconPassword = UIImage(named: "ic_password_pressed")
            iconPasswordRe = UIImage(named: "ic_password_pressed")
            iconName = UIImage(named: "ic_name_pressed")
        }else{
            iconEmail = UIImage(named: "ic_email_normal")
            iconPassword = UIImage(named: "ic_password_normal")
            iconPasswordRe = UIImage(named: "ic_password_normal")
            iconName = UIImage(named: "ic_name_normal")
        }
        
        if(style == 1){
            icon.image = iconEmail
            setPlaceholder(isEdit, "이메일 주소")
        }else if(style == 2){
            icon.image = iconPassword
            setPlaceholder(isEdit, "비밀번호")
        }else if(style == 3){
            icon.image = iconPasswordRe
            setPlaceholder(isEdit, "비밀번호 확인")
        }else if(style == 4){
            icon.image = iconName
            setPlaceholder(isEdit, "이름")
        }
        
        setLineBottom(isEdit)
        
        
        
        
    }
    
    func setPlaceholder( _ isEdit: Bool, _ placeHolderText: String){
        if(isEdit){
            textField.attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: [NSForegroundColorAttributeName: hj.rgb(0x0033a0) ])
        }else{
            textField.attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        }
    }
    
    func setLineBottom( _ isEdit: Bool){
        if(isEdit){
            bottomLine.image = UIImage(named: "textfields_map_mini")
        }else{
            bottomLine.image = UIImage(named: "textfields_general_pressed")
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
        let nib = UINib(nibName: "TextfieldJoin", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    
    
}
