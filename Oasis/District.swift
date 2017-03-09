//
//  District.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 19..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import Foundation
import RealmSwift

class District: Object{
    dynamic var _id = -1
    dynamic var adm_cd = ""
    dynamic var adm_single_cd = ""
    dynamic var name = ""
    dynamic var ref = ""
    dynamic var adm_group = ""
    dynamic var tab_name = ""
    
    var locals = List<District>()
    
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
