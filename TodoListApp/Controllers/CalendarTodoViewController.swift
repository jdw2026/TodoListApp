//
//  CalendarTodoViewController.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/06/19.
//

import UIKit
import FSCalendar

final class CalendarTodoViewController: UIViewController {
    
    private let calendarTodoView = CalendarTodoView()
    let todoManager = CoreDataManager.shared
    var dicDataArray: [String: [TodoData]] = [:]
    var completedTodoCount: [String: Int] = [:]
    var todoCompleteRate: [String: Double?] = [:]
    
    override func loadView() {
        self.view = calendarTodoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarTodoView.calendarView.delegate = self
        calendarTodoView.calendarView.dataSource = self
        setupTodo()
        NotificationCenter.default.addObserver(self, selector: #selector(handleModalDismissed), name: NSNotification.Name("ModalDismissed"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ModalDismissed"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("-----------------캘린더뷰", #function)
        setupTodo()
        calendarTodoView.calendarView.setCurrentPage(Date(), animated: false)
        calendarTodoView.calendarView.reloadData()
    }
    
    func setupTodo() {
        let allTodoData = todoManager.getAllToDoListFromCoreData()
        dicDataArray = todoDataToDic(todoDataList: allTodoData)
        print("캘린더뷰 셋업 투두")
    }
    
    func todoDataToDic(todoDataList: [TodoData]) -> [String: [TodoData]] {
        var dicDataArray: [String: [TodoData]] = [:]
        var completedCount: [String: Int] = [:]
        
        for todoData in todoDataList {
            let date = DateHelper.ymdDateFormat(date: todoData.todoDate)
            
            //해당 날짜의 키값이 있으면
            if dicDataArray.keys.contains(date) {
                //투두데이터 추가
                dicDataArray[date]?.append(todoData)
                //해당 날짜의 키값이 없으면
            }else {
                //새롭게 배열 만들기
                dicDataArray[date] = [todoData]
                completedCount[date] = 0
            }
            
            if todoData.checkStatus == true {
                completedCount[date, default: 0] += 1
            }
            
        }
        
        //각 날짜별로 order 순으로 정렬
        for (date, todos) in dicDataArray {
            dicDataArray[date] = todos.sorted(by: { $0.order < $1.order })
        }
        completedTodoCount = completedCount
        return dicDataArray
    }
    
    @objc func handleModalDismissed() {
        viewWillAppear(true)
    }
    
}


extension CalendarTodoViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        
        //캘린더의 날짜를 yyyy-mm-dd 형식으로 변경
        let todoDate = DateHelper.ymdDateFormat(date: date)
        
        let cell = calendar.dequeueReusableCell(withIdentifier: "CustomCalendarCell", for: date, at: position) as! CustomCalendarCell
        
        var newCompletionRate: Double? = nil
        
        //데이터에서 해당날짜의 데이터가 있다면 -> 커스텀 셀 리턴
        if dicDataArray.keys.contains(todoDate) {
            
            if let todos = dicDataArray[todoDate] {
                let completedCount = completedTodoCount[todoDate] ?? 0
                newCompletionRate = Double(completedCount) / Double(todos.count)
                todoCompleteRate = [ todoDate : newCompletionRate ]
            }
        }
        
        if cell.completionRate != newCompletionRate {
            cell.completionRate = newCompletionRate
        }
        
        return cell
    }
    
    
    // 일요일에 해당되는 모든 날짜의 색상 red로 변경, 투두 완료율이 100% 이면 날짜 색상 white 로 변경
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        
        var newCompletionRate: Double = 0.0
        
        let todoDate = DateHelper.ymdDateFormat(date: date)
        //데이터에서 해당날짜의 데이터가 있다면
        if dicDataArray.keys.contains(todoDate) {
            if let todos = dicDataArray[todoDate] {
                //체크표시된 갯수
                let completedCount = completedTodoCount[todoDate] ?? 0
                newCompletionRate = Double(completedCount) / Double(todos.count)
            }
        }
        
        if Calendar.current.shortWeekdaySymbols[day] == "일" {
            if newCompletionRate == 1.0 {
                return .white
            } else {
                return .red
            }
        // 평일
        } else {
            if newCompletionRate == 1.0 {
                return .white
            } else {
                return .black
            }
        }
    }
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        //            calendar.appearance.title
        calendar.reloadData()
    }
    
    //날짜 선택시
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //투두 추가 또는 수정 하기
        let vc = AddTodoViewController()
        vc.calendarDate = date
        self.present(vc, animated: true, completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let today = DateHelper.ymdDateFormat(date: Date())
        let dateString = DateHelper.ymdDateFormat(date: date)
        
        if today == dateString {
            return "오늘"
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleOffsetFor date: Date) -> CGPoint {
        let today = DateHelper.ymdDateFormat(date: Date())
        let dateString = DateHelper.ymdDateFormat(date: date)

        if today == dateString {
            return CGPoint(x: 0, y: 8)
        } else {
            return CGPoint(x: 0, y: 0)
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleOffsetFor date: Date) -> CGPoint {
        let today = DateHelper.ymdDateFormat(date: Date())
        if dicDataArray.keys.contains(today) {
            return CGPoint(x: 0, y: 25)
        } else {
            return CGPoint(x: 0, y: 13)
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        
        //선택된 날짜 색 평일 -> 블랙, 일 -> 레드
        let day = Calendar.current.component(.weekday, from: date) - 1
        let dateString = DateHelper.ymdDateFormat(date: date)
        
        if Calendar.current.shortWeekdaySymbols[day] == "일" {
            return UIColor.red
        }else {
            if todoCompleteRate[dateString] == 1.0 {
                return UIColor.white
            }else {
                return UIColor.black
            }
        }
    }


}


