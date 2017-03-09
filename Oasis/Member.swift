//
//  Member.swift
//  Oasis
//
//  Created by mac on 2017. 2. 2..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import Foundation
import RealmSwift

class Member: Object{
    dynamic var _id = -1
    dynamic var member_enc = ""
    dynamic var password = ""
    dynamic var name = ""
    dynamic var nickname = ""
    dynamic var email = ""
    dynamic var flag_join = ""
    dynamic var flag_visit = ""
    dynamic var jumin = ""
    dynamic var gender = ""
    dynamic var grade = ""
    dynamic var mobile = ""
    dynamic var mobile2 = ""
    dynamic var birth = ""
    dynamic var sorl = ""
    dynamic var postnum = ""
    dynamic var address = ""
    dynamic var address2 = ""
    dynamic var bank_id = ""
    dynamic var bank_name = ""
    dynamic var account = ""
    dynamic var memo = ""
    dynamic var is_sms = ""
    dynamic var date_login = ""
    dynamic var login_count = ""
    dynamic var token = ""
    dynamic var date_in = ""
    dynamic var is_leave = ""
    dynamic var certify_code = ""
    dynamic var addr_cd = ""
    dynamic var selfcert_id = ""
    dynamic var state = ""
    dynamic var cert_email_id = ""
    dynamic var cert_naver_id = ""
    dynamic var cert_kakao_id = ""
    dynamic var cert_google_id = ""
    dynamic var cert_mobile_id = ""
    dynamic var visit_path = ""
    dynamic var manage_1 = ""
    dynamic var manage_2 = ""
    dynamic var manage_9 = ""
    dynamic var app = ""
    dynamic var id = ""
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    
    
    
}
