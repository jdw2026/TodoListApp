//
//  CoreDataManager.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/06/22.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName = "TodoData"
    
    // MARK: - [Read] 모든 투두리스트 읽어오기
    func getAllToDoListFromCoreData() -> [TodoData] {
        var toDoList: [TodoData] = []
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // 정렬순서를 정해서 요청서에 넘겨주기
            let dateOrder = NSSortDescriptor(key: "todoDate", ascending: true)
            let orderOrder = NSSortDescriptor(key: "order", ascending: true)
            
            request.sortDescriptors = [dateOrder, orderOrder]
            
            do {
                // 임시저장소에서 (요청서를 통해서) 데이터 가져오기 (fetch메서드)
                if let fetchedToDoList = try context.fetch(request) as? [TodoData] {
                    toDoList = fetchedToDoList
                    print("모든 투두리스트 가져오기 성공")
                }
            } catch {
                print("모든 투두리스트 가져오는 것 실패")
            }
        }
        
        return toDoList
    }
    
    //MARK: - [Read] 특정날짜 투두 읽어오기
    func getParticularTodoData(date: Date) -> [TodoData] {
            
        var todoData: [TodoData] = []
        
        // 날짜의 시작 시간과 끝 시간을 계산
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // Core Data 요청 준비
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: "TodoData")
            request.predicate = NSPredicate(format: "todoDate >= %@ AND todoDate < %@", startOfDay as NSDate, endOfDay as NSDate)
            let dateOrder = NSSortDescriptor(key: "order", ascending: true)
            request.sortDescriptors = [dateOrder]
            
            do {
                // 데이터 가져오기
                let fetchedToDoList = try context.fetch(request) as! [TodoData]
                todoData = fetchedToDoList
                print("특정날짜 투두 가져오기 성공: \(todoData.count) 개의 항목")
            } catch {
                print("특정날짜 데이터 가져오기 실패: \(error.localizedDescription)")
            }
        } else {
            print("컨텍스트가 nil입니다.")
        }
        
        return todoData
    }
    
    
    //MARK: - 투두 내용으로 검색해서 읽어오기
    func getSearchForWords(words: String) -> [TodoData] {
        
        var todoDate: [TodoData] = []
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: "TodoData")
            request.predicate = NSPredicate(format: "todoText CONTAINS[cd] %@", words)
            let dateOrder = NSSortDescriptor(key: "todoDate", ascending: true)
            request.sortDescriptors = [dateOrder]
            
            do {
                // 데이터 가져오기
                let fetchedToDoList = try context.fetch(request) as! [TodoData]
                todoDate = fetchedToDoList
                print("투두 단어검색 가져오기 성공: \(todoDate.count) 개의 항목")
            } catch {
                print("투두 단어검색 가져오기 실패: \(error.localizedDescription)")
            }
        }else {
            print("context nil")
        }
        
        return todoDate
    }
    
    
    
    
    
    
    // MARK: - [Create] 투두 생성하기
    func saveNewToDoData(toDoText: String, checkStatus: Bool, indexPath: Int, todoDate: Date) {
        // 임시저장소 있는지 확인
        if let context = context {
            // 임시저장소에 있는 데이터를 그려줄 형태 파악하기
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                
                // 임시저장소에 올라가게 할 객체만들기 (NSManagedObject ===> ToDoData)
                if let toDoData = NSManagedObject(entity: entity, insertInto: context) as? TodoData {
    
                    toDoData.todoText = toDoText
                    toDoData.todoDate = todoDate
                    toDoData.checkStatus = checkStatus
                    toDoData.uuid = UUID()
                    toDoData.order = Int64(indexPath)
                    
                    appDelegate?.saveContext()
                    print("새로운 투두 저장성공")
                }
            }
        }
    }
    
    
    // MARK: - [Update] 투두 수정하기 (일치하는 데이터 찾아서 ===> 수정)
    func updateToDoTextAndStatus(newToDoData: TodoData) {

        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "uuid = %@", newToDoData.uuid as CVarArg)
            
            do {
                // 요청서를 통해서 데이터 가져오기
                if let fetchedTodo = try context.fetch(request) as? [TodoData] {
                    //ToDoData에 실제 데이터 재할당(바꾸기) ⭐️
                    fetchedTodo.first?.todoText = newToDoData.todoText
                    fetchedTodo.first?.checkStatus = newToDoData.checkStatus
                    
                    appDelegate?.saveContext()
                    print("업데이트 성공")
                }
            }catch {
                print("업데이트 실패")
            }
        }
    }
    
    //MARK: - [Update] 투두리스트 순서 변경 업데이트하기 ------- 섹션간 이동시 날짜도 바꿀수 있게 만들어야함
    func todoOrderChangeUpdate(data: TodoData,date: Date, destinationOrder: Int64) {
        
        let uuid = data.uuid
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "uuid = %@", uuid as CVarArg)
            
            do{
                if let fetchedTodo = try context.fetch(request) as? [TodoData]{
                    
                    guard let firstData = fetchedTodo.first else { return }
                    firstData.order = destinationOrder
                    firstData.todoDate = date
                    appDelegate?.saveContext()
                    print("투두리스트 순서변경 성공")
                }
            }catch {
                print("투두리스트 순서변경 실패")
            }
        }
    }
    
    
    
    // MARK: - [Delete] 투두 삭제하기 (일치하는 데이터 찾아서 ===> 삭제)
    func deleteToDo(data: TodoData) {
        // 날짜 옵셔널 바인딩
        let uuid = data.uuid
        
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "uuid = %@", uuid as CVarArg)
            
            do {
                // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기) (fetch메서드)
                if let fetchedTodo = try context.fetch(request) as? [TodoData] {
                    
                    guard let firstData = fetchedTodo.first else { return }
                    // 임시저장소에서 (요청서를 통해서) 데이터 삭제하기 (delete메서드)
                    context.delete(firstData)
                    appDelegate?.saveContext()
                    print("투두 삭제 성공")
                }
                
            } catch {
                print("지우는 것 실패")
                
            }
        }
        print("임시저장소 없음")
    }
    
    
}
