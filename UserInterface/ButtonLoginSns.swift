//
//  ButtonLoginSns.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 6..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//


import UIKit

//@IBDesignable
class ButtonLoginSns: UIView {
  
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    let hj = hjUtil()
    @IBInspectable var style: Int = 0 {
        didSet {
            if style == 0{ //Naver
                buttonStyle("ic_logo_naver", "네이버 계정으로 로그인", UIColor.white, hj.rgb(0x1b9100) , 10)
            }else if style == 1{
                buttonStyle("ic_logo_kakao", "카카오 계정으로 로그인", UIColor.black, hj.rgb(0xf9e81e) , 10)
            }else if style == 2{
                buttonStyle("ic_logo_google", "구글 계정으로 로그인", UIColor.white, hj.rgb(0xcc3732) , 10)
            }
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
        let nib = UINib(nibName: "ButtonLoginSns", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    func buttonStyle( _ iconName: String, _ titleText: String, _ titleTextColor: UIColor, _ backColor: UIColor, _ radius: CGFloat ){
        
        //radius
        container.layer.cornerRadius = radius
        
        //icon
        icon.image = UIImage(named: iconName)
        
        //title
        title.text = titleText
        
        //title color
        title.textColor = titleTextColor
        
        //background color
        container.backgroundColor = backColor
        
    }
    
    
}
