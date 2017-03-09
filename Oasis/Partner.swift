//
//  Partner.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 20..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import Foundation
import RealmSwift

class Partner: Object{
    dynamic var _id = -1
    dynamic var partner_name = ""
    dynamic var code = ""
    dynamic var bcode = ""
    dynamic var phone1 = ""
    dynamic var phone2 = ""
    dynamic var manager_name = ""
    dynamic var addr = ""
    dynamic var x = ""
    dynamic var y = ""
    dynamic var bus = ""
    dynamic var metro = ""
    dynamic var branch = ""
    dynamic var service_name = ""
    dynamic var fax_num = ""
    dynamic var sell_num = ""
    dynamic var email = ""
    dynamic var bank_id = ""
    dynamic var bank_num = ""
    dynamic var bank_name = ""
    dynamic var last = ""
    
    dynamic var district_name = ""
    dynamic var adm_single_code = ""
    dynamic var tab_name = ""
    
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
