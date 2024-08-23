//
//  UIViewController+Handler.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/08/12.
//

import UIKit

extension UIViewController {
    func handleTap(sender: UITapGestureRecognizer, tableView: UITableView, footerButtonTag: [Int], uiView: UIView, vc: UIViewController) {
        if sender.state == .ended {
            // 탭한 위치를 테이블뷰 내의 좌표로 변환
            let location = sender.location(in: tableView)
            // 탭한 위치가 셀 위에 있을 경우
            if tableView.indexPathForRow(at: location) != nil {
            } else { // 탭한 위치가 셀 밖(테이블뷰 내의 빈 공간)
                // 풋터뷰의 버튼을 탭한 경우
                if let footerView = tableView.tableFooterView {
                    // 풋터뷰 안에 버튼 태그로 찾기
                    for tag in footerButtonTag {
                        guard let button = footerView.viewWithTag(tag) as? UIButton else { return }
                        // 버튼의 프레임을 화면 전체 위치로 변환
                        let buttonFrameInSuperview = button.convert(button.bounds, to: self.view)
                        // 탭한 위치를 전체 위치로
                        let location = sender.location(in: self.view)
                        // 탭된 위치가 버튼의 프레임 안에 있는지 확인
                        if buttonFrameInSuperview.contains(location) {
                            return // 테이블뷰 리로드 또는 키보드 내리지 않게 리턴처리
                        }
                    }
                    
                }
                // 풋터뷰를 제외한 셀 밖을 탭한 경우
                view.endEditing(true)
                guard let view = uiView as? AddTodoView else { return }
                let date = view.datePicker.date
                view.dateTextField.text = DateHelper.dateFormat(date: date)
                guard let vc = vc as? AddTodoViewController else { return }
                vc.setupData(date: date)
                view.tableView.reloadData()
            }
        }
        sender.cancelsTouchesInView = false
    }
}

