//
//  DateHelper.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/08/11.
//

import UIKit

final class DateHelper {
    
    static func ymdDateFormat(date: Date) -> String {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        myFormatter.timeZone = TimeZone.current
        let savedDateString = myFormatter.string(from: date)
        return savedDateString
    }


    static func dateFormat(date: Date) -> String {
        let myFormatter = DateFormatter()
        myFormatter.locale = Locale(identifier: "ko_KR")
        myFormatter.dateFormat = "yyyy. MM. dd (EEE)"
        let savedDateString = myFormatter.string(from: date)
        return savedDateString
    }

    static func dayStringToDate(text : String) -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy. MM. dd (EEE)"
        guard let textDate = formatter.date(from: text) else { return Date() }
        return textDate
    }


    //날짜를 UTC 시간대에서 -> 로컬 시간대로 조정하는 함수
    static func adjustToLocalTime(_ date: Date) -> Date {
        let timeZone = TimeZone.current
        let seconds = TimeInterval(timeZone.secondsFromGMT(for: date))
        return date.addingTimeInterval(seconds)
    }

}
