//
//  Checklist.swift
//  CheckLists
//
//  Created by Boo on 6/4/20.
//  Copyright © 2020 boo. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "Name")
        coder.encode(items,forKey: "Items")
        coder.encode(iconName,forKey: "IconName")
    }
    
    func countUnCheckedItems() -> Int {
        var count = 0;
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
    
    var name = ""
    var items = [ChecklistItem]()
    var iconName: String
    
//    init(name: String) {
//        self.name = name
//        iconName = "Appointments"
//        super.init()
//    }
    
    
    // 便利初始化
    convenience init(name: String){
        self.init(name: name,iconName: "No Icon")
    }
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    // 从plist文件中读取对象时，用这个方法。
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "Name") as! String
        items = coder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = coder.decodeObject(forKey: "IconName") as! String
        super.init()
    }
}
