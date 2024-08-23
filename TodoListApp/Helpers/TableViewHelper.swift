//
//  TableViewHelper.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/08/12.
//

import UIKit

final class TableViewHelper {
    
    static func createDeleteAction(
           todoManager: CoreDataManager,
           tableView: UITableView,
           indexPath: IndexPath,
           date: Date,
           vc: UIViewController,
           completion: @escaping (Bool) -> Void
       ) -> UIContextualAction {
           
           let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
               
               // 코어데이터에서 삭제
               let todoData = todoManager.getParticularTodoData(date: date)[indexPath.row]
               todoManager.deleteToDo(data: todoData)
               
               switch vc {
               case let allTodo as AllTodoListViewController:
                   allTodo.setupData()
                   tableView.reloadData()
               case let addTodo as AddTodoViewController:
                   addTodo.setupData(date: date)
                   tableView.deleteRows(at: [indexPath], with: .automatic)
               default:
                   tableView.deleteRows(at: [indexPath], with: .automatic)
                   break
               }
               
               // 코어 데이터에 오더번호 업데이트
               let lastTodoData = todoManager.getParticularTodoData(date: date).last
               
               if lastTodoData != todoData {
                   let todoItems = todoManager.getParticularTodoData(date: date)
                   for index in indexPath.row..<todoItems.count {
                       let todoItem = todoItems[index]
                       todoManager.todoOrderChangeUpdate(data: todoItem, date: date, destinationOrder: Int64(index))
                   }
               }
               // 작업 완료 처리
               completionHandler(true)
               completion(true)
           }
           return deleteAction
       }
    
    //셀 삭제버튼 색상, 이미지 설정
    static func configureDeleteActionAppearance(_ action: UIContextualAction) {
        action.backgroundColor = UIColor.red
        action.image = UIImage(systemName: "trash.fill")
    }
    
}
