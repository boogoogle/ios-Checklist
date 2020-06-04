//
//  ChecklistItem.swift
//  CheckLists
//
//  Created by Boo on 6/1/20.
//  Copyright © 2020 boo. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject,NSCoding,NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    func encode(with coder: NSCoder) {
        coder.encode(text, forKey: "Text")
        coder.encode(checked, forKey: "Checked")
    }
    
    required init?(coder: NSCoder) { // 问号表示init可能会返回失败或者nil
        text = coder.decodeObject(forKey: "Text") as! String
        checked = coder.decodeBool(forKey: "Checked")
        super.init()
    }
    override init() {
        super.init()
    }
    
    
    
    var text = ""
    var checked = false
    func toggleChecked(){
        checked = !checked
    }
    // 一个好的面向对象设计原则是你应该尽可能的去让每个对象自己去改变自己的状态
}
