//
//  TaskVC.swift
//  ToDoList
//
//  Created by Gb2 on 21/05/19.
//

import UIKit

class TaskVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //PROPERTIES
    @IBOutlet weak var tableViewAllTask: UITableView!
    @IBOutlet weak var segMenu: UISegmentedControl!
    
    //VARIABLE
    fileprivate let obj_DatabaseModel = DatabaseModel.init()
    fileprivate var arrResults = [typeAliasDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        segMenu.selectedSegmentIndex = 0
        self.segMenuAction(segMenu)
    }
    
    //MARK:- BUTTON ACTION
    @IBAction func btnAddTaskAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "idAddNewTask") as! AddNewTask
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func segMenuAction(_ sender: UISegmentedControl) {
        arrResults = [typeAliasDictionary]()
        if sender.selectedSegmentIndex == 0 {
            arrResults = obj_DatabaseModel.getAllTasks(isMark: false)
        }
        else {
            arrResults = obj_DatabaseModel.getAllTasks(isMark: true)
        }
        self.tableViewAllTask.reloadData()
    }
    
    // MARK: - Table view datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        
//        [["TASK_MESSAGE": cjxisjduddu, "TASK_DATE": 2019-05-22 06:27:55 +0000, "ROW_ID": 1], ["TASK_MESSAGE": dhzxhhxhx, "TASK_DATE": 2019-05-22 06:31:11 +0000, "ROW_ID": 2], ["TASK_MESSAGE": gfjmbukk, "TASK_DATE": 2019-05-22 06:32:39 +0000, "ROW_ID": 3]]

        let dict: typeAliasDictionary = arrResults[indexPath.row]
        cell.textLabel?.text = dict[FLD_TASK_MESSAGE] as? String ?? ""
        return cell
    }

    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            // TODO: Delete todo
            let dict: typeAliasDictionary = self.arrResults[indexPath.row]
            print(dict)
            if let id = dict[FLD_ROW_ID]  {
                self.obj_DatabaseModel.deleteTask(stId: id as! String)
            }
            self.segMenuAction(self.segMenu)
        }
        action.image = #imageLiteral(resourceName: "trash")
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Mark") { (action, view, completion) in
            let dict: typeAliasDictionary = self.arrResults[indexPath.row]
            if let id = dict[FLD_ROW_ID]  {
                if self.obj_DatabaseModel.openDatabaseConnection() {
                    let update_stmt: String = "UPDATE \(TBL_TODO_MST) SET \(FLD_TASK_TYPE) = 'mark' WHERE \(FLD_ROW_ID) = '\(id)'"
                    if self.obj_DatabaseModel.database.executeStatements(update_stmt) { print("\(TBL_TODO_MST) - Data Updated") }
                    else { print(self.obj_DatabaseModel.database.lastError(), self.obj_DatabaseModel.database.lastErrorMessage()) }
                    self.obj_DatabaseModel.closeDatabaseConnection()
                }
            }
            self.segMenuAction(self.segMenu)
        }
        action.image = #imageLiteral(resourceName: "check")
        action.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segMenu.selectedSegmentIndex == 0 {
            let dict: typeAliasDictionary = self.arrResults[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "idAddNewTask") as! AddNewTask
            vc.dictTask = dict
            vc.isEdit = true
            present(vc, animated: true, completion: nil)
        }
    }

}
