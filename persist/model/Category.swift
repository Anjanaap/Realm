//
//  Category.swift
//  persist
//
//  Created by Chitra Hari on 27/08/19.
//  Copyright © 2019 Chitra Hari. All rights reserved.
//

import Foundation
import  RealmSwift

class Category : Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
