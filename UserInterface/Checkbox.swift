//
//  Checkbox.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 9..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import Foundation
import UIKit

protocol CheckboxDelegate: class {
    func onCheck(sender: Checkbox)
}

//@IBDesignable
class Checkbox: UIView{
    var delegate: CheckboxDelegate?
    
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var check: UIButton!
    @IBAction func touchUpInside(_ sender: UIButton) {
        setChecked(!checked!)
        delegate?.onCheck(sender: self)
        
    }
 

    var checked: Bool? = false
    var iTag: Int = 0
    
    @IBInspectable var tig: Int = 0 {
        didSet {
            iTag = tig
        }
    }
    @IBInspectable var isChecked: Bool = false {
        didSet {
            setChecked(isChecked)
        }
    }
    func setChecked( _ isChecked: Bool){
        checked = isChecked
        if(isChecked){
            check.setImage(UIImage(named: "ic_check_box_pressed"), for: .normal)
            
            
        }else{
            check.setImage(UIImage(named: "ic_check_box_normal"), for: .normal)
      
        }
    }
    
    
    
    
    
    
    func setupUI(){
    
        
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
        let nib = UINib(nibName: "Checkbox", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
}
