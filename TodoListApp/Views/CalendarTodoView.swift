//
//  CalendarTodoView.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/06/19.
//

import UIKit
import FSCalendar

final class CalendarTodoView: UIView {
    
    
    lazy var calendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.backgroundColor = .clear
        //양 사이드 년,월 지우기
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        //지난달, 다음달의 날짜 색
//        calendar.appearance.titlePlaceholderColor = UIColor.lightGray.withAlphaComponent(0.4)
        calendar.placeholderType = .none
        
        //헤더 설정
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 23)
        
        //요일 UI
        calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 18)
        calendar.appearance.weekdayTextColor = .black
        
        //날짜 UI
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 18)
        //오늘 날짜 표시를 숨기기
        calendar.appearance.todayColor = UIColor.clear
        
        calendar.appearance.selectionColor = .clear //-> 선택 원 투명색으로
        
        calendar.appearance.subtitleFont = UIFont.boldSystemFont(ofSize: 14)
        calendar.appearance.subtitleTodayColor = .red
        calendar.appearance.subtitleSelectionColor = .red
        
        //일요일 빨간글씨
        calendar.calendarWeekdayView.weekdayLabels.first!.textColor = .red
        calendar.register(CustomCalendarCell.self, forCellReuseIdentifier: "CustomCalendarCell")
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setupConstraints()
        super.updateConstraints()
    }
    
    func setupView() {
        self.addSubview(calendarView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            calendarView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            calendarView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            calendarView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100)
        ])
    }
}
