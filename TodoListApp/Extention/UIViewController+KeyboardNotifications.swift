//
//  UIViewController+KeyboardNotifications.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/08/12.
//

import UIKit

extension UIViewController {
    
    func setupKeyboardNotifications(showSelector: Selector, hideSelector: Selector) {
        //키보드가 올라갈때 관찰후 알림
        NotificationCenter.default.addObserver(self, selector: showSelector, name: UIResponder.keyboardWillShowNotification, object: nil)
        //키보드가 내려갈때 관찰후 알림
        NotificationCenter.default.addObserver(self, selector: hideSelector, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func adjustForKeyboard(notification: NSNotification, tableView: UITableView, bottomConstraint: NSLayoutConstraint, safeAreaBottomInset: CGFloat, vc: UIViewController) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) {
            let keyboardHeight = keyboardSize.cgRectValue.height - safeAreaBottomInset
            
            if bottomConstraint.constant == 0 {
                bottomConstraint.constant -= keyboardHeight
            }

            guard vc is AllTodoListViewController else {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: safeAreaBottomInset, right: 0)
                tableView.contentInset = contentInsets
                tableView.scrollIndicatorInsets = contentInsets
                
                DispatchQueue.main.async {
                    if let lastRow = tableView.indexPathsForVisibleRows?.last {
                        tableView.scrollToRow(at: lastRow, at: .bottom, animated: true)
                    }
                }
                return
            }
        }
    }
    
    func resetAfterKeyboardDismiss(tableView: UITableView, bottomConstraint: NSLayoutConstraint) {
        if bottomConstraint.constant != 0 {
            bottomConstraint.constant = 0
        }
        
        let contentInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
