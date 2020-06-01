//
//  AddItemViewController.swift
//  CheckLists
//
//  Created by Boo on 6/1/20.
//  Copyright © 2020 boo. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController,UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBAction func cancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(){
        print("输入了: \(textField.text)")
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder() // 自动激活文本框,弹出键盘
    }
    
    // 委托TextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        if newText.length > 0 {
            doneBarButton.isEnabled = true
        } else {
            doneBarButton.isEnabled = false
        }
        return true
    }
    
    
}
