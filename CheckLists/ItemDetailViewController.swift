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
    
    var itemToEdit: ChecklistItem? // 因为在新增时, itemToEdit可能是nil,所以它的类型是"可选型", 这就是问号的作用
    
    weak var delegate: ItemDetailViewControllerDelegate?
    // 委托通常以weak形式声明,
    // weak 描述委托和视图控制器之间的关系; 问号(?)表示委托是"可选型"
    
    @IBAction func cancel(){
//        dismiss(animated: true, completion: nil)
        print("cancel in ItemDetailViewController")
        delegate?.itemDetailViewControllerDidCancel(self)
        // 这里的问号(?)告诉swift如果delegate为nil的话就不要发送消息
    }
    
    @IBAction func done(){
        print("输入了: \(String(describing: textField.text))")
        
        
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didiFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder() // 自动激活文本框,弹出键盘
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit{ // 使用它你首先要进行解包(unwrap)。通过一个特殊的语法完成这一功能：
            title = "Edit Item" // title 是视图控制器的内建属性,
            textField.text = item.text
            doneBarButton.isEnabled = true
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
