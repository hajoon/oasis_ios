//
//  Bank.swift
//  Oasis
//
//  Created by mac on 2017. 2. 2..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import Foundation
import RealmSwift

class Bank: Object{
    dynamic var _id = -1
    dynamic var name = ""
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    
    
    
}
