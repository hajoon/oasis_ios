//
//  Appraise.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 12..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import Foundation
import RealmSwift

class Appraise: Object{
    dynamic var _id = -1
    dynamic var loan_id = ""
    dynamic var partner_empl_id = ""
    dynamic var mort_id = ""
    dynamic var date_in = ""
    dynamic var no = ""
    dynamic var appraise_date = ""
    dynamic var amount = ""
    dynamic var rate = ""
    dynamic var admin_id = ""
    dynamic var history = ""
    dynamic var is_permission = ""
    dynamic var note = ""
    dynamic var flag_type = ""
    
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
