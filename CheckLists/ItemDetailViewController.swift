//
//  ItemDetailViewController.swift
//  CheckLists
//
//  Created by Boo on 6/1/20.
//  Copyright © 2020 boo. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didiFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController,UITextFieldDelegate {
    // 添加UITextFieldDelegate 后
    // 需要手动添加storyboard中的textField 的delegate 连线到  ItemDetailViewController
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    var dueDate = Date()
    
    var itemToEdit: ChecklistItem? // 因为在新增时, itemToEdit可能是nil,所以它的类型是"可选型", 这就是问号的作用
    
    weak var delegate: ItemDetailViewControllerDelegate?
    // 委托通常以weak形式声明,
    // weak 描述委托和视图控制器之间的关系; 问号(?)表示委托是"可选型"
    
    var datePickerVisible = false
    var rowsOfDateSection = 2
    
    @IBAction func cancel(){
//        dismiss(animated: true, completion: nil)
        print("cancel in ItemDetailViewController")
        delegate?.itemDetailViewControllerDidCancel(self)
        // 这里的问号(?)告诉swift如果delegate为nil的话就不要发送消息
    }
    
    @IBAction func done(){
//        print("输入了: \(String(describing: textField.text))")
        
        if let item = itemToEdit {
            item.text = textField.text!
            item.shouleRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            delegate?.itemDetailViewController(self, didiFinishEditing: item)
            item.scheduleNotification()
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            item.shouleRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            delegate?.itemDetailViewController(self, didFinishAdding: item)
            item.scheduleNotification()
        }
        
    }
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    
    /**
                使点击效果失效.点击table cell 不会有任何效果
     */
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        print("willSelectRowAt", indexPath)
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        
        if !datePickerVisible {
            showDatePicker()
        } else {
            hideDatePicker()
        }
    }
    
    /**
         当你为静态table view重写了数据源后，你还需要提供委托方法：tableView(indentationLevelForRowAt)
         
         这不是你经常使用的一个方法，但是因为你动了用于静态table view的数据源，所以你必须重写它。
     
         如果不重写这个方法,会报错:
                Terminating app due to uncaught exception 'NSRangeException', reason: '*** __boundsFail: index 2 beyond bounds [0 .. 1]'
     */
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        print(indexPath, indexPath.row, indexPath.section, "indentationLevelForRowAt")
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0,section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1  {
            return rowsOfDateSection
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder() // 自动激活文本框,弹出键盘
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit{ // 使用它你首先要进行解包(unwrap)。通过if let 一个特殊的语法完成这一功能：
            title = "Edit Item" // title 是视图控制器的**内建属性**,
            textField.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouleRemind
            dueDate = item.dueDate
        }
        updateDueDateLabel()
    }
    
    func updateDueDateLabel() {
        let formatter = DateFormatter() // 返回当地时间
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    func showDatePicker(){
        datePickerVisible = true
        rowsOfDateSection = 3
        datePicker.setDate(dueDate, animated: false)
        
        let indexPathDatePicker = IndexPath(row:2, section: 1)
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        
        
    }
    func hideDatePicker() {
        datePickerVisible = false
        let indexPathDateRow = IndexPath(row: 1, section: 1)
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        if let cell = tableView.cellForRow(at: indexPathDateRow) {
            cell.detailTextLabel!.textColor = UIColor.cyan
        }
        rowsOfDateSection = 2
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
        
        tableView.endUpdates()
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
//        hideDatePicker()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(datePickerVisible) {
            hideDatePicker()
        }
    }
    // 委托TextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
//        if newText.length > 0 {
//            doneBarButton.isEnabled = true
//        } else {
//            doneBarButton.isEnabled = false
//        }
    
        doneBarButton.isEnabled = newText.length > 0
        return true
    }
    
    
}
    
