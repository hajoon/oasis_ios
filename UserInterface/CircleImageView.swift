//
//  CircleImageView.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 10..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

//@IBDesignable
class CircleImageView: UIView {
    @IBOutlet weak var image: UIImageView!

    @IBInspectable var imageName: String = "ic_profile" {
        didSet {
            image.image = UIImage(named: imageName)
            
        }
    }
 
    @IBInspectable var radius: Int = 33 {
        didSet {
            image.layer.cornerRadius = CGFloat(radius)
            
        }
    }
    
    func setupUI(){
        
        //image.layer.cornerRadius = image.frame.size.width / 2;
        image.clipsToBounds = true;
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(someAction(_:)))
        view.addGestureRecognizer(gesture)
        
        
    }
    
    
    func someAction(_ sender:UITapGestureRecognizer){
        
        NotificationCenter.default.post(name: Notification.Name("CircleImageViewTap"), object: nil)
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
        let nib = UINib(nibName: "CircleImageView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
