//
//  AddListsTableViewController.swift
//  CheckLists
//
//  Created by Boo on 6/4/20.
//  Copyright © 2020 boo. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate,UINavigationControllerDelegate {
    
    var dataModel: DataModel!
    // 这里的感叹号是必须的，因为当app启动时的一个短暂时间内dataModel会为nil。
    // 但是并不需要把dataModel声明为可选型，带上一个问号，因为一旦dataModel有值后，就再也不会为nil了。
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData() // 更新所有的cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        // 每个视图控制器都有一个内建的导航控制器属性，你可以使用navigationController?.delegate读取它，因为它是个可选型，所以你要使用一个问号。
        print(dataModel.lists.count, "dataModel.lists")
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            // 不适用index !=-1 判断, 从而保证了index是位于0到lists.count之间的值
            // 这样就避免了向dataModel.lists[index]请求某个index的对象时，这个对象不存在的情况。
            let checklist = dataModel.lists[index]
//            print(checklist)
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let checklist = dataModel.lists[indexPath.row]
        let cell = makeCell(for: tableView)
        cell.textLabel!.text = "\(checklist.name)"
        cell.accessoryType = .detailDisclosureButton
        
        var subText = ""
        if(checklist.items.count == 0) {
            subText = "No Items"
        } else {
            let unDoneNum = checklist.countUnCheckedItems()
            if unDoneNum == 0 {
                subText = "All Done"
            } else {
                subText = "\(unDoneNum) Remaining"
            }
        }
        cell.detailTextLabel!.text = subText
        
        cell.imageView!.image = UIImage(named: checklist.iconName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let ctrl = segue.destination as! ChecklistsViewController
            // 这里seque的destination是ChecklistViewController, 而不是UINavigationController
            // 到Add/Edit 的转场是modally presented方式,针对于嵌入导航控制器中的视图控制器
            // 这次是 Push 型的转场,直接跳转到 ChecklistViewController
            ctrl.checklist = (sender as! Checklist)
        } else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destination as! UINavigationController
            let ctrl = navigationController.topViewController as! ListDetailViewController
            ctrl.delegate = self
            ctrl.checklistToEdit = nil
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        present(navigationController, animated: true, completion: nil)
    }
    
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
            // 手动闯建一个UITableViewCell
            // 需要指定style
        }
    }
    
    
    
    
    
    
    
    /* 协议方法写在Controller底部,这是一个习惯? */
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
//        let newRowIndex = dataModel.lists.count
//        let indexPath = IndexPath(row: newRowIndex, section: 0)
//        let ips = [indexPath]
//        tableView.insertRows(at: ips, with: .automatic)
//        以上代码不需要了,我们用tableView.reloadData()来实现整体刷新
        tableView.reloadData()

        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
//        if let index = dataModel.lists.firstIndex(of: checklist){
//            let indexPath = IndexPath(row: index, section: 0)
//            if let cell = tableView.cellForRow(at: indexPath){
//                cell.textLabel!.text = checklist.name
//            }
//        }
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    /* UINavigationController 的委托 */
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 无论何时，导航控制器中出现一个新的视图的时候，这个方法都会被调用。
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    

}
