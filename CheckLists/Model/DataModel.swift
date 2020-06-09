//
//  DataModel.swift
//  CheckLists
//
//  Created by Boo on 6/5/20.
//  Copyright © 2020 boo. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init(){
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    // 这种 get{} set{} 的形式叫做  **计算属性**
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize() // [防止UserDefaults中保存的数据和Checklists.plist 中的内容不同步](https://www.jianshu.com/p/e044fb65a429)
        }
    }
    
    func registerDefaults(){
        let dictionary: [String: Any] = [
            "ChecklistIndex": -1,
            "FirstTime": true,
            "ChecklistItemId": 0]
        UserDefaults.standard.register(defaults: dictionary )
    }
    func handleFirstTime(){
        let uds = UserDefaults.standard
        let firstTime = uds.bool(forKey: "FirstTime")
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            uds.set(false, forKey: "FirstTime")
            uds.synchronize()
        }
        
    }
    func sortChecklists(){
        lists.sort(by: {
            checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending
        })
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    func saveChecklists(){
        do{
            print(dataFilePath())
            print(lists.count)
            let archiverData = try? NSKeyedArchiver.archivedData(withRootObject: lists, requiringSecureCoding: false) // false or true 啥区别
            try archiverData?.write(to: dataFilePath())
        }catch {
            print("save checklists error: \(error)")
        }
    }
    
    func loadChecklists(){
        let path = dataFilePath()
//        print(path)
        
        if let data = try?Data(contentsOf: path) {
            //            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            //            items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
            //            unarchiver.finishDecoding()
            // 上面的api过时了, 参考这里https://www.swiftdevcenter.com/save-and-get-objects-using-nskeyedarchiver-and-nskeyedunarchiver-swift-5/
            do{
                print("data", data)
                let iis = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [Checklist]
                lists = iis
                //                print(iis)
            } catch {
                print(error)
            }
        }
    }
    
    
    // class 关键字意味着你可以在不引用DataModel的前提下,调用这个方法
    class func nextChecklistItemID() -> Int {
        let uds = UserDefaults.standard
        let itemID = uds.integer(forKey: "ChecklistItemID")
        uds.set(itemID + 1, forKey: "ChecklistItemID")
        uds.synchronize()
        return itemID
    }
}
