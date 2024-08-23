//
//  TodoData+CoreDataProperties.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/06/18.
//
//

import Foundation
import CoreData


extension TodoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoData> {
        return NSFetchRequest<TodoData>(entityName: "TodoData")
    }

    @NSManaged public var todoText: String
    @NSManaged public var todoDate: Date
    @NSManaged public var checkStatus: Bool
    @NSManaged public var order: Int64
    @NSManaged public var uuid: UUID

}

extension TodoData : Identifiable {

}
