//
//  Loan.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 12..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import Foundation
import RealmSwift

class Loan: Object{
    
    dynamic var _id = -1
    dynamic var member_id = ""
    dynamic var partner_id = ""
    dynamic var admin_id = ""
    dynamic var date_in = ""
    dynamic var date_start = ""
    dynamic var date_end = ""
    dynamic var date_visit = ""
    dynamic var date_visit_json = ""
    dynamic var payday = ""
    dynamic var pay_date = ""
    dynamic var amount = ""
    dynamic var nopay = ""
    dynamic var inter_daily = ""
    dynamic var interest_daily = ""
    dynamic var flag_state = ""
    dynamic var flag_reg = ""
    dynamic var min_img_count = ""
    dynamic var promise_img_count = ""
    dynamic var mobile = ""
    dynamic var loan_account = ""
    dynamic var deposit_account = ""
    dynamic var visit_where = ""
    dynamic var address = ""
    dynamic var idcard = ""
    dynamic var idcard2 = ""
    dynamic var reg_no1 = ""
    dynamic var reg_no2 = ""
    dynamic var is_minwon = ""
    dynamic var is_promise = ""
    dynamic var is_del = ""
    dynamic var location = ""
    dynamic var etc_memo = ""
    dynamic var action_no = ""
    dynamic var action_start = ""
    dynamic var action_end = ""
    dynamic var action_price = ""
    dynamic var repay_day = ""
    dynamic var repay_bank = ""
    dynamic var reapy_account = ""
    
    dynamic var mort_name = ""
    dynamic var loan_id = ""
    dynamic var start_date = ""
    dynamic var end_date = ""
    dynamic var overdue_start = ""
    dynamic var partner_name = ""
    dynamic var addr = ""
    dynamic var x = ""
    dynamic var y = ""
    dynamic var bus = ""
    dynamic var metro = ""
    dynamic var estm_id = ""
    dynamic var title = ""
    dynamic var cnt_addimage = ""
    dynamic var item_count = ""
    dynamic var auction_no = ""
    dynamic var auction_start = ""
    dynamic var auction_end = ""
    dynamic var auction_price = ""
    dynamic var auction_cancel = ""
    dynamic var repay_amount = ""
    dynamic var rate = ""
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
}
