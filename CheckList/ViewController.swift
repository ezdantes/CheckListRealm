//
//  ViewController.swift
//  CheckList
//
//  Created by Vladislav Barinov on 08.07.2020.
//  Copyright © 2020 Vladislav Barinov. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    var items:Results<TaskList>!
    let realm = try! Realm()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    }
    
    @IBAction func addButton(_ sender: Any) {
     
        addAlertNewItem()
    }
    
    func addAlertNewItem()  {
        let alert = UIAlertController(title: "Новая задача", message: "Пожалуйста заполните поле", preferredStyle: .alert)
        
        var alertTextField: UITextField!
        alert.addTextField { (textField) in
            
            alertTextField = textField
                textField.placeholder = "Новая задача"
                
            }

        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { (action) in
            
            guard let text = alertTextField.text, text.isEmpty == false else { return }
            
            let task = TaskList()
            task.task = text
            try! self.realm.write {
                self.realm.add(task)
            }
            
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items = realm.objects(TaskList.self)
        if items.count != 0 {
            return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        let item = items[indexPath.row]
        cell.textLabel?.text = item.task
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func delete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (_, _, _) in
            guard let self = self else { return }
            
            let editingRow = self.items[indexPath.row]
            try! self.realm.write {
                self.realm.delete(editingRow)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.reloadData()
            }
 
        }
        return deleteAction
    }
    
    func edit(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, _) in
            
            let alert = UIAlertController(title: "Хотите изменить? ", message: "В другой раз, друг", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
        
        return editAction
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = self.edit(rowIndexPathAt: indexPath)
        let delete = self.delete(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipe
    }
    //    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    //
    //        let deleteItem = UITableViewRowAction(style: .default, title: "Удалить") { (_, _) in
    //            self.items.remove(at: indexPath.row)
    //            self.tableView.reloadData()
    //        }
    //        return [deleteItem]
    //    }
    
}
