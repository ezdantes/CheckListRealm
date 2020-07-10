//
//  Model.swift
//  CheckList
//
//  Created by Vladislav Barinov on 08.07.2020.
//  Copyright © 2020 Vladislav Barinov. All rights reserved.
//

import Foundation
import RealmSwift


class TaskList: Object {
    @objc dynamic var task = ""
    @objc dynamic var completed = false
}
