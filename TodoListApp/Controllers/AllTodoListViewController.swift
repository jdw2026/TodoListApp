//
//  TodoListViewController.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/06/19.
//

import UIKit

final class AllTodoListViewController: UIViewController {
    
    let allTodoListView = AllTodoListView()
    let todoManager = CoreDataManager.shared
    let searchController = UISearchController()
    var searchTodoData: [TodoData]? = []
    var dicDataArray: [String: [TodoData]]? = [:]
    var sectionTitles: [String]?  = []
    var safeAreaBottomInset: CGFloat = 0
    var sectionNum: [Int] = []
    
    override func loadView() {
        view = allTodoListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allTodoListView.tableView.delegate = self
        allTodoListView.tableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        //테이블 뷰의 드래그 활성화
        allTodoListView.tableView.dragInteractionEnabled = true
        allTodoListView.tableView.dragDelegate = self
        allTodoListView.tableView.dropDelegate = self
        
        setupData()
        setupSearchBar()
        setupNotification()
        
        //touchesBegan 이 먹히지 않아 제스처 추가
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function, "올투두리스트뷰컨트롤러")
        setupData()
        allTodoListView.tableView.reloadData()
//        if dicDataArray != [:] {
//            scrollToClosestDateSection(in: allTodoListView.tableView, sections: sectionTitles!)
//        }
//        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        allTodoListView.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //키보드 올라갔을때 키보드와 테이블뷰 사이 뜨는 공간
        safeAreaBottomInset = view.safeAreaInsets.bottom
    }
    
    // 서치바 셋팅
    func setupSearchBar() {
        navigationItem.searchController = searchController
        // 첫글자 대문자 설정 없애기
        searchController.searchBar.autocapitalizationType = .none
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupData() {
        let allTodoData = todoManager.getAllToDoListFromCoreData()
        dicDataArray = todoDataToDic(todoDataList: allTodoData)
        sectionTitles = dicDataArray?.keys.sorted()
    }
    
    //노티피케이션 셋팅
    func setupNotification() {
        setupKeyboardNotifications(showSelector: #selector(moveUpAction), hideSelector: #selector(moveDownAction))
    }
    
    @objc func moveUpAction(notification: NSNotification) {
        adjustForKeyboard(notification: notification, tableView: allTodoListView.tableView, bottomConstraint: allTodoListView.tableViewBottomAnchorConstraint, safeAreaBottomInset: safeAreaBottomInset, vc: self)
    }
    
    @objc func moveDownAction() {
        resetAfterKeyboardDismiss(tableView: allTodoListView.tableView, bottomConstraint: allTodoListView.tableViewBottomAnchorConstraint)
    }
    
    //코어데이터에서 가져온 모든투두리스트 딕셔너리 형태로 바꿔주기
    func todoDataToDic(todoDataList: [TodoData]) -> [String: [TodoData]] {
        var dicDataArray: [String: [TodoData]] = [:]
        
        for todoData in todoDataList {
            let date = DateHelper.dateFormat(date: todoData.todoDate)
            if dicDataArray[date] != nil {
                dicDataArray[date]?.append(todoData)
            } else {
                dicDataArray[date] = [todoData]
            }
        }
        //각 날짜별로 order 순으로 정렬
        for (date, todos) in dicDataArray {
            dicDataArray[date] = todos.sorted(by: { $0.order < $1.order })
        }
        return dicDataArray
    }
    
    //데이터 리스트중 오늘 날짜 찾기, 없으면 그전날로
    func findClosestDateSection(from date: Date, in sections: [String]) -> String? {
        var searchDate = date
        while true {
            let dateString = DateHelper.dateFormat(date: searchDate)
            if sections.contains(dateString) {
                return dateString
            }
            guard let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: searchDate) else {
                return nil
            }
            searchDate = previousDate
        }
    }
    
    //원하는 곳으로 스크롤하는 함수
    func scrollToClosestDateSection(in tableView: UITableView, sections: [String]?) {
        let today = Date()
        guard let sections = sections else { return }
        if let closestDateString = findClosestDateSection(from: today, in: sections) {
            if let sectionIndex = sections.firstIndex(of: closestDateString) {
                let indexPath = IndexPath(row: 0, section: sectionIndex)
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        
    }
    
    //⭐️ 테이블뷰, 스크롤뷰에서 터치 이벤트가 안먹힘... 따로 제스처 추가로 해결 아래 코드 handleTap 메서드로...
    @objc func handleTap(sender: UITapGestureRecognizer) {
        handleTap(sender: sender, tableView: allTodoListView.tableView, footerButtonTag: sectionNum, uiView: allTodoListView, vc: self)
    }
    
    @objc func footerPlusButtonTapped(sender: UIButton) {
        guard let dayString = sender.titleLabel?.text else { return }
        let date = DateHelper.dayStringToDate(text: dayString)
        
        TodoHelper.makeNewTodo(todoManager: todoManager, date: date, vc: self, section: sender.tag, tableView: allTodoListView.tableView)
    }
    
    @objc func allDeleteButtonTapped(sender: UIButton) {
        guard let stringDate = sender.titleLabel?.text else { return }
        let date = DateHelper.dayStringToDate(text: stringDate)
        AlerHelper.showAlertController(date: date, vc: self, todoManager: todoManager, uiView: allTodoListView)
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
}


extension AllTodoListViewController: UITableViewDelegate {
    
    // 셀 밀어서 삭제하기 편집액션
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //삭제된 투두의 날짜 찾기
        let todoDateString = self.sectionTitles?[indexPath.section]
        let todoDate = DateHelper.dayStringToDate(text: todoDateString!)
        
        let deleteAction = TableViewHelper.createDeleteAction(todoManager: todoManager, tableView: tableView, indexPath: indexPath, date: todoDate, vc: self) { success in }
        
        TableViewHelper.configureDeleteActionAppearance(deleteAction)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension AllTodoListViewController: UITableViewDataSource {
    
    //몇개의 섹션을 만들건지
    func numberOfSections(in tableView: UITableView) -> Int {
        //저장된 투두리스트 날짜별 갯수만큼 생성
        print("------------------\(sectionTitles?.count)")
        return dicDataArray?.keys.count ?? 0
    }
    
    //한개의 섹션에 몇개의 셀을 만들지
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //날짜별로 들어있는 투두갯수만큼
        guard let date = sectionTitles?[section] else { return 0 }
        //키를 이용해 들어있는 투두갯수 카운트
        return dicDataArray?[date]?.count ?? 0
    }
    
    //어떤셀을 보여줄지? 어떤데이터를 담아서?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        
        guard let date = sectionTitles?[indexPath.section] else { return cell }
        if let todosForData = dicDataArray?[date] {
            let todoData = todosForData[indexPath.row]
            cell.todoData = todoData
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = sectionTitles?[section] else {return UIView()}
        let headerView = allTodoListView.createSectionHeaderView(withTitle: title)
        if let button = headerView.subviews.compactMap({ $0 as? UIButton }).first {
            button.addTarget(self, action: #selector(allDeleteButtonTapped), for: .touchUpInside)
            button.titleLabel?.text = title
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = allTodoListView.createSectionFooterView()
        guard let title = sectionTitles?[section] else {return UIView()}
        if let button = footerView.subviews.compactMap({ $0 as? UIButton }).first {
            button.addTarget(self, action: #selector(footerPlusButtonTapped), for: .touchUpInside)
            button.titleLabel?.text = title
            button.tag = section
            sectionNum.append(section)
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //테이블뷰 셀 이동 메서드
      func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
          
          
          
          
          
//          // allData에 모든 데이터 배열 넣기
          guard var allData = dicDataArray else { return }
//          
//          // 섹션키(날짜) 정렬
          let sectionKeys = Array(allData.keys).sorted()
          let sourceSectionKey = sectionKeys[sourceIndexPath.section] //이동하는 데이터 섹션 키
//          let sourceDate = DateHelper.dayStringToDate(text: sourceSectionKey) // 이동하는 데이터 날짜
          let destinationSectionKey = sectionKeys[destinationIndexPath.section] //이동될 데이터 섹션키
//          let desticationDate = DateHelper.dayStringToDate(text: destinationSectionKey) // 이동될 데이터 날짜
          
          
          
//          print("1")
//          // 이동할 데이터 임시 저장
          guard var sourceSectionData = allData[sourceSectionKey] else { return }
          let movedData = sourceSectionData[sourceIndexPath.row]
          
          
          self.dicDataArray?[sourceSectionKey]?.remove(at: sourceIndexPath.row)
          self.dicDataArray?[destinationSectionKey]?.append(movedData)
          
          
          
          
//          print("2")
//          // 이동할 데이터 삭제
//          sourceSectionData.remove(at: sourceIndexPath.row)
//          if sourceSectionData.isEmpty {
//              allData.removeValue(forKey: sourceSectionKey)
//          } else {
//              allData[sourceSectionKey] = sourceSectionData
//          }
//          print("3")
//          // 이동할 데이터 추가
//          guard var destinationSectionData = allData[destinationSectionKey] else { return }
//          destinationSectionData.insert(movedData, at: destinationIndexPath.row)
//          allData[destinationSectionKey] = destinationSectionData
//          print("4")
//          //테이블뷰 업데이트 시작
//          tableView.beginUpdates()
//          print("5")
//          tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
//          print("6")
//          if sourceSectionData.isEmpty {
//              tableView.deleteSections(IndexSet(integer: sourceIndexPath.section), with: .automatic)
//          }
////          setupData()
//          
//          print("7")
//          tableView.endUpdates()
//          
//          if sourceSectionData.isEmpty {
////
////              if destinationIndexPath.section == tableView.numberOfSections-1 {
////                             adjustedDestinationIndexPath = IndexPath(row: destinationIndexPath.row, section: destinationIndexPath.section - 1)
//              
//              print("8")
//          } else {
//              print("9")
//              //이동하는 섹션에 행이 남아있을때 순서 코어데이터에 다시 저장
//              if let updatedSourceSectionData = allData[sourceSectionKey] {
//                  for (index, todoData) in updatedSourceSectionData.enumerated() {
//                      todoData.order = Int64(index)
//                      todoManager.todoOrderChangeUpdate(data: todoData, date: sourceDate, destinationOrder: Int64(index))
//                  }
//              }
//              
//          }
//          print("10")
//          //데이터가 옮겨진 섹션의 순서와 날짜 코어데이터에 다시 저장
//          if let updatedDestinationSectionData = allData[destinationSectionKey] {
//              for (index, todoData) in updatedDestinationSectionData.enumerated() {
//                  todoData.order = Int64(index)
//                  todoManager.todoOrderChangeUpdate(data: todoData, date: desticationDate, destinationOrder: Int64(index))
//                               }
//          }
//          print("11")
//          setupData()
      }
    
    
}

extension AllTodoListViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension AllTodoListViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        print("performDropWith")
    }
}

//MARK: - SearchBar extention
extension AllTodoListViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTodoData = []
        setupData()
        allTodoListView.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.isEmpty {
            searchTodoData = []
            setupData()
            allTodoListView.tableView.reloadData()
        }
    }
}

extension AllTodoListViewController: UISearchResultsUpdating {
    // 유저가 글자를 입력하는 순간마다 호출되는 메서드 ===> 일반적으로 다른 화면을 보여줄때 구현
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text == "" {
            setupData()
        } else {
            let words = searchController.searchBar.text ?? ""
            searchTodoData = todoManager.getSearchForWords(words: words)
            dicDataArray = todoDataToDic(todoDataList: searchTodoData!)
            sectionTitles = dicDataArray?.keys.sorted()
        }
        allTodoListView.tableView.reloadData()
    }
}
