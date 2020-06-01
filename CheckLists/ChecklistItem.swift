//
//  ChecklistItem.swift
//  CheckLists
//
//  Created by Boo on 6/1/20.
//  Copyright © 2020 boo. All rights reserved.
//

import Foundation

class ChecklistItem {
    var text = ""
    var checked = false
    func toggleChecked(){
        checked = !checked
    }
    // 一个好的面向对象设计原则是你应该尽可能的去让每个对象自己去改变自己的状态
}
