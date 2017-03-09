//
//  MainParallaxHeader.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 11..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

class MainParallaxHeader: UICollectionViewCell {

    @IBAction func lightTouchUpInside(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("lightTouchUpInside"), object: nil)
    }
    @IBAction func alarmTouchUpInside(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("alarmTouchUpInside"), object: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
