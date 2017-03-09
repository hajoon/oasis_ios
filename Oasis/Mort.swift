//
//  Mort.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 12..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import Foundation
import RealmSwift

class Mort: Object{
    dynamic var _id = -1
    dynamic var category_id = ""
    dynamic var brand = ""
    dynamic var member_id = ""
    dynamic var loan_id = ""
    dynamic var title = ""
    dynamic var buy_date = ""
    dynamic var buy_price = ""
    dynamic var buy_route = ""
    dynamic var template_date = ""
    dynamic var date_in = ""
    dynamic var date_update = ""
    dynamic var character = ""
    dynamic var memo = ""
    dynamic var cnt_addimage = ""
    dynamic var flag_reg = ""
    dynamic var flag_result = ""
    dynamic var flag_state = ""
    dynamic var is_reloan = ""
    dynamic var is_del = ""
    
    dynamic var amount = ""
    dynamic var category_name = ""
    dynamic var in_date = ""
    dynamic var rate = ""
    dynamic var date_appraise = ""
    dynamic var history = ""
    dynamic var reg_date = ""
    dynamic var appraise_id = ""
    dynamic var appraise_date = ""
    dynamic var appraise_amount = ""
    dynamic var partner_id = ""
    dynamic var admin_id = ""
    dynamic var is_permission = ""
    
    
    dynamic var is_check = false
    
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
