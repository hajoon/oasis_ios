//
//  Category.swift
//  Oasis
//
//  Created by mac on 2017. 2. 1..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    dynamic var _id = -1
    dynamic var me = ""
    dynamic var name = ""
    dynamic var parent = ""
    dynamic var contents = ""
    dynamic var type = ""
    dynamic var icon_name = ""
    dynamic var template = ""
    dynamic var seq = -1
    dynamic var date_in = ""
    
    dynamic var icon_pressed = NSData()
    dynamic var icon_normal = NSData()
    dynamic var icon_mini = NSData()
    dynamic var is_pressed = false
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    
    
    
}
