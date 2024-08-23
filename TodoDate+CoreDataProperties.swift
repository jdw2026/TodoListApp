//
//  TodoDate+CoreDataProperties.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/06/18.
//
//

import Foundation
import CoreData


extension TodoDate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoDate> {
        return NSFetchRequest<TodoDate>(entityName: "TodoDate")
    }

    @NSManaged public var todoText: String?
    @NSManaged public var todoDate: String?
    @NSManaged public var checkStatus: Bool
    @NSManaged public var todoPercentage: Int64

}

extension TodoDate : Identifiable {

}
