//
//  AddListsTableViewController.swift
//  CheckLists
//
//  Created by Boo on 6/4/20.
//  Copyright © 2020 boo. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {
    var lists: [Checklist]
    
    
    required init?(coder: NSCoder) {
        lists = [Checklist]() // 给lists变量一个值
        super.init(coder: coder) // 从故事模板中读取视图
        
        for i in 0..<5{
            let name = "listName-- \(i)"
            let cl = Checklist(name: name)
            lists.append(cl)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        let checklist = lists[indexPath.row]
        cell.textLabel!.text = "\(checklist.name)"
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let ctrl = segue.destination as! ChecklistsViewController
            // 这里seque的destination是ChecklistViewController, 而不是UINavigationController
            // 到Add/Edit 的转场是modally presented方式,针对于嵌入导航控制器中的视图控制器
            // 这次是 Push 型的转场,直接跳转到 ChecklistViewController
            ctrl.checklist = (sender as! Checklist)
        }
    }

    
    
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            // 手动闯建一个UITableViewCell
            // 需要指定style
        }
    }
    

}
