//
//  MortSceneCollectionViewCell.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 18..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

class MortSceneCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var check: Checkbox!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var image: CircleImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var memo: UILabel!
 
    var id = -1
    
    
}
