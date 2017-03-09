//
//  CameraCollectionViewCell.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 24..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

class CameraCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    
    var isAdded = false
    var key = ""
    
}
