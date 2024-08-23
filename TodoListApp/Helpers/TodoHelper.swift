//
//  TodoHelper.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/08/12.
//

import UIKit

final class TodoHelper {
    
    static func makeNewTodo(todoManager: CoreDataManager, date: Date, vc: UIViewController, section: Int, tableView: UITableView) {
        let dataCount = todoManager.getParticularTodoData(date: date).count
        todoManager.saveNewToDoData(toDoText: "", checkStatus: false, indexPath: dataCount, todoDate: date)
        
        switch vc {
        case let allTodoVC as AllTodoListViewController: allTodoVC.setupData()
        case let addTodoVC as AddTodoViewController: addTodoVC.setupData(date: date)
        default: break
        }
        
        let indexPath = IndexPath(row: dataCount, section: section)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        // 특정 시간 딜레이 후에 커서 활성화
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let cell = tableView.cellForRow(at: indexPath) as? TodoTableViewCell {
                cell.todoTextFeild.becomeFirstResponder() // 커서 활성화
            }
        }
    }

    
    
}
