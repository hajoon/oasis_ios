//
//  MainFloatingIcon.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 13..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

protocol MainFloatingIconDelegate: class {
    func touchUpInsideFloatingIcon(sender: MainFloatingIcon)
}
class MainFloatingIcon: UIView {
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var image: UIImageView!

    var dele: MainFloatingIconDelegate!
    
    
    func setupUI(){
        image.image = UIImage(named: "ic_float_inquiry")
        back.layer.cornerRadius = back.frame.size.width / 2;
        back.clipsToBounds = true;
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(someAction(_:)))
        view.addGestureRecognizer(gesture)
        
        
    }
    
    
    func someAction(_ sender:UITapGestureRecognizer){
        
        dele.touchUpInsideFloatingIcon(sender: self)
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
        let nib = UINib(nibName: "MainFloatingIcon", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
