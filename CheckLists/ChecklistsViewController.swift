//
//  ViewController.swift
//  CheckLists
//
//  Created by Boo on 5/29/20.
//  Copyright © 2020 boo. All rights reserved.
//

import UIKit

class ChecklistsViewController: UITableViewController {
    
    @IBAction func addItem(){
        let newRowIndex = items.count
        
        let item = ChecklistItem()
        item.text = "I am a new row"
        item.checked = false
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        // 因为insertRows的at参数要求一个数组,所以上面构造了一个数组
        tableView.insertRows(at: indexPaths, with: .automatic)// automatic tableView插入新行时的动画
    }
    var items: [ChecklistItem]
    //这一行声明了items会用来存储一个ChecklistItem对象的数组
    //但是它并没有实际创建一个数组
    //在这一时刻，items还没有值
    required init?(coder aDecoder: NSCoder) { // TODO 这个是啥?
        items = [ChecklistItem]()
        //这一行实例化了这个数组。现在items包含了一个有效的数组对象
        //但是这个数组内部还不存在ChecklistItem对象
        
        for i in 0..<10 {
            let row0item = ChecklistItem()
            row0item.text = "Walk the dog\(i)"
            row0item.checked = false
            items.append(row0item)
        }
       
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /**
     [iOS Apprentice 第11课](https://www.jianshu.com/p/d0876b0b9928)
            下划线 _ :
        这个参数有两个名字:
            - numberOfRowsInSection在调用这个方法的时候使用. 我们称之为参数的"外部名称"
            - section: 是参数的"内部名称"
            
            如果函数第一个参数不需要外部名称,则用下划线_ 代替,
     
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) // 获取一个prototype cell 的拷贝
        let item = items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    func configureText(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }


}

