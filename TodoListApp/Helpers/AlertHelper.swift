//
//  AlertHelper.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/08/11.
//

import UIKit

final class AlerHelper {
    
    static func showAlertController(date: Date, vc: UIViewController, todoManager: CoreDataManager, uiView: UIView) {
        
        let alert = UIAlertController(title: "전체삭제", message: "해당 날짜의 할 일을 모두 삭제하겠습니까? (개별 삭제는 왼쪽으로 밀어 삭제하세요)", preferredStyle: .alert)
        
        // Button
        let ok = UIAlertAction(title: "확인", style: .default) { action in
            let todoDatas = todoManager.getParticularTodoData(date: date)
            for data in todoDatas {
                todoManager.deleteToDo(data: data)
            }
            
            if let addVc = vc as? AddTodoViewController {
                addVc.setupData(date: date)
            } else if let allVc = vc as? AllTodoListViewController {
                allVc.setupData() 
            }
            
            // 데이터 삭제 후 테이블뷰 리로드
            for subView in uiView.subviews {
                if let tableView = subView as? UITableView {
                    tableView.reloadData()
                }
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        //present
        vc.present(alert, animated: true, completion: nil)
        
    }

}
