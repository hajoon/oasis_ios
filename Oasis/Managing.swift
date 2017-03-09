//
//  Managing.swift
//  Oasis
//
//  Created by mac on 2017. 2. 2..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import Foundation
import RealmSwift

class Managing: Object{
    dynamic var _id = -1
    dynamic var me = ""
    dynamic var date_in = ""
    dynamic var img_count = ""
    dynamic var manage_id = ""
    dynamic var readhit = ""
    dynamic var writer = ""
    dynamic var title = ""
    dynamic var content = ""
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    
    
    
}
