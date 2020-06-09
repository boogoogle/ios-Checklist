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
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouleRemind = false
    var itemId: Int
    
    func encode(with coder: NSCoder) {
        coder.encode(text, forKey: "Text")
        coder.encode(checked, forKey: "Checked")
        coder.encode(itemId, forKey: "ItemId")
        coder.encode(dueDate, forKey: "DueDate")
        
    }
    
    required init?(coder: NSCoder) { // 问号表示init可能会返回失败或者nil
        text = coder.decodeObject(forKey: "Text") as! String
        checked = coder.decodeBool(forKey: "Checked")
        itemId = coder.decodeInteger(forKey: "ItemId")
        dueDate = coder.decodeObject(forKey: "DueDate") as! Date
        super.init()
    }
    override init() {
        itemId = DataModel.nextChecklistItemID()
        super.init()
    }
    
    init(text: String) {
        self.text = text
        itemId = DataModel.nextChecklistItemID()
        super.init()
    }
    
    func scheduleNotification() {
        if shouleRemind && dueDate > Date() {
            print("schedule a notification")
        }
    }
    
    
    func toggleChecked(){
        checked = !checked
    }
    // 一个好的面向对象设计原则是你应该尽可能的去让每个对象自己去改变自己的状态
}
