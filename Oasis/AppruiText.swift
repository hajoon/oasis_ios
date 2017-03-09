
//
//  AppruiText.swift
//  Oasis
//
//  Created by mac on 2017. 2. 10..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

class AppruiText: UIView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var arrow: UIImageView!
    @IBAction func textEditingDidBegin(_ sender: UITextField) {
        if type != "cal" { return }
        datePickerSetup(sender: sender)
    }
    
    
    var type = "text"
    
    func setupUI(){
        
    }

    
    func datePickerSetup(sender: UITextField){
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
 
    
    // 7
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        
        dateFormatter.timeStyle = .none
        
        dateFormatter.dateFormat = "yyyy-MM-dd";
        
        text.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    
    
    
    //init view
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    convenience init(frame: CGRect, type: String) {
        
        self.init(frame: frame)
        self.type = type
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
         view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AppruiText", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
}
