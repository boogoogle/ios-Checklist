//
//  ViewController.swift
//  CheckLists
//
//  Created by Boo on 5/29/20.
//  Copyright © 2020 boo. All rights reserved.
//

import UIKit

class ChecklistsViewController: UITableViewController, ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        print("ChecklistsViewController, cancel")
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dismiss(animated: true, completion: nil)
    }
    func itemDetailViewController(_ controller: ItemDetailViewController, didiFinishEditing item: ChecklistItem) {
        
        if let index = checklist.items.firstIndex(of: item){ // [T]firstIndex(of: T)只能是相同的类型的元素
//            print(index,"item index")
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
//    @IBAction func addItem(){
//        let newRowIndex = items.count
//
//        let item = ChecklistItem()
//        item.text = "I am a new row"
//        item.checked = false
//        items.append(item)
//
//        let indexPath = IndexPath(row: newRowIndex, section: 0)
//        let indexPaths = [indexPath]
//        // 因为insertRows的at参数要求一个数组,所以上面构造了一个数组
//        tableView.insertRows(at: indexPaths, with: .automatic)// automatic tableView插入新行时的动画
//    }
//    var items: [ChecklistItem]
    //这一行声明了items会用来存储一个ChecklistItem对象的数组
    //但是它并没有实际创建一个数组
    //在这一时刻，items还没有值
    var checklist: Checklist!
    // 为什么这里要用!可选型,
    // 如果使用? ,那么在viewDidload中,还是需要使用?解包.
    // 使用!标识这个变量一定是Checklist类型
    
    
//    required init?(coder aDecoder: NSCoder) { // TODO 这个是啥?
        // items = [ChecklistItem]()
        // 这一行实例化了这个数组。现在items包含了一个有效的数组对象
        // 但是这个数组内部还不存在 ChecklistItem 对象
        
//        for i in 0..<10 {
//            let row0item = ChecklistItem()
//            row0item.text = "Walk the dog\(i)"
//            row0item.checked = false
//            items.append(row0item)
//        }
       
//        super.init(coder: aDecoder)
//        print("Documents folder is \(documentsDirectory())")
//        print("Data file path is \(dataFilePath())")
//    }
    
    // 转场时被UIKit 调用
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = checklist.name
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
        return checklist.items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        // 获取一个prototype cell 的拷贝, 通过indexPath, 这是标准cell
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
//            cell.accessoryType = .checkmark
            label.text = "√"
        } else {
//            cell.accessoryType = .none
            label.text = ""
        }
        label.textColor = view.tintColor

    }
    func configureText(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    

}

