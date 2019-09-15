//
//  Item.swift
//  persist
//
//  Created by Chitra Hari on 27/08/19.
//  Copyright © 2019 Chitra Hari. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items" )
}
