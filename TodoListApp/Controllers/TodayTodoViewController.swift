//
//  TodayTodoViewController.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/06/18.
//

import UIKit

final class TodayTodoViewController: UIViewController {
    
    let todayTodoview = TodayTodoView()
    let todoManager = CoreDataManager.shared
    var safeAreaBottomInset: CGFloat = 0
    
    override func loadView() {
        view = todayTodoview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //touchesBegan 이 먹히지 않아 제스처 추가
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        
        setupNavibar()
        setupButtonAction()
        setupNotification()
        
        todayTodoview.tableView.dataSource = self
        todayTodoview.tableView.delegate = self
        //테이블 뷰의 드래그 활성화
        todayTodoview.tableView.dragInteractionEnabled = true
        todayTodoview.tableView.dragDelegate = self
        todayTodoview.tableView.dropDelegate = self
    }
    
    // 화면에 다시 진입할때마다 다시 테이블뷰 그리기 (업데이트 등 제대로 표시)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todayTodoview.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //키보드 올라갔을때 키보드와 테이블뷰 사이 뜨는 공간
        safeAreaBottomInset = view.safeAreaInsets.bottom
    }
    
    func setupNavibar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 불투명으로
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black ]
        navigationItem.title = "오늘 할 일"
        
        // 네비게이션바 우측에 Plus 버튼 만들기
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigationItemPlusButtonTapped))
        plusButton.tintColor = .black
        navigationItem.rightBarButtonItem = plusButton
    }
    
    func setupButtonAction() {
        todayTodoview.footerTodoPlusButton.addTarget(self, action: #selector(footerTodoPlusButtonTapped), for: .touchUpInside)
        todayTodoview.allDeleteButton.addTarget(self, action: #selector(headerViewAllDeleteButtonTapped), for: .touchUpInside)
    }
    
    //노티피케이션 셋팅
    func setupNotification() {
        setupKeyboardNotifications(showSelector: #selector(moveUpAction), hideSelector: #selector(moveDownAction))
    }
    
    @objc func moveUpAction(notification: NSNotification) {
        adjustForKeyboard(notification: notification, tableView: todayTodoview.tableView, bottomConstraint: todayTodoview.tableViewBottomAnchorConstraint, safeAreaBottomInset: safeAreaBottomInset, vc: self)
    }
    
    @objc func moveDownAction() {
        resetAfterKeyboardDismiss(tableView: todayTodoview.tableView, bottomConstraint: todayTodoview.tableViewBottomAnchorConstraint)
    }
    
    @objc func navigationItemPlusButtonTapped() {
        let vc = AddTodoViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    //⭐️ 테이블뷰, 스크롤뷰에서 터치 이벤트가 안먹힘... 따로 제스처 추가로 해결 아래 코드 handleTap 메서드로...
    @objc func handleTap(sender: UITapGestureRecognizer) {
        handleTap(sender: sender, tableView: todayTodoview.tableView, footerButtonTag: [100], uiView: todayTodoview, vc: self)
    }
    
    @objc func footerTodoPlusButtonTapped() {
        TodoHelper.makeNewTodo(todoManager: todoManager, date: Date(), vc: self, section: 0, tableView: todayTodoview.tableView)
    }
    
    @objc func headerViewAllDeleteButtonTapped() {
        if todoManager.getParticularTodoData(date: Date()).count > 0 {
            AlerHelper.showAlertController(date: Date(), vc: self, todoManager: todoManager, uiView: self.todayTodoview)
        }
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
}

//MARK: - 테이블뷰 extention
extension TodayTodoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoManager.getParticularTodoData(date: Date()).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todayTodoview.tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        
        let todoData = todoManager.getParticularTodoData(date: Date())
        cell.todoData = todoData[indexPath.row]
        cell.checkBoxButtonPressed = { (senderCell) in
            
            guard let data = senderCell.todoData else { return }
            
            //투두 체크박스에 체크를 해제함
            if senderCell.checkBox.isSelected == false{
                self.todoManager.updateToDoTextAndStatus(newToDoData: data)
                print(data.checkStatus, "뷰컨트롤러 - 펄스자리")
            }else { //투두 체크박스에 체크함
                self.todoManager.updateToDoTextAndStatus(newToDoData: data)
                print(data.checkStatus, "뷰컨트롤러 - 트루자리")
            }
        }
        
        cell.textFeildEnd = { (senderCell) in
            guard let data = senderCell.todoData else { return }
            if data.todoText != "" {
                self.todoManager.updateToDoTextAndStatus(newToDoData: data)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //테이블뷰 셀 이동에 메서드
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //오늘의 투두데이터 모두 가져오기
        var todoDataArray = todoManager.getParticularTodoData(date: Date())
        //움직이는 셀의 데이터 임시저장
        let moveData = todoDataArray[sourceIndexPath.row]
        //오늘의 투두데이터에서 지우고 옮긴 인덱스에 넣어주기
        todoDataArray.remove(at: sourceIndexPath.row)
        todoDataArray.insert(moveData, at: destinationIndexPath.row)
        //모든 데이터의 인덱스번호 업데이트후 코어데이터에도 변경사항 저장
        for (index, todoData) in todoDataArray.enumerated() {
            todoData.order = Int64(index)
            todoManager.todoOrderChangeUpdate(data: todoData, date: Date(), destinationOrder: Int64(index))
        }
        tableView.reloadData()
    }
}

extension TodayTodoViewController: UITableViewDelegate {
    // 셀 밀어서 삭제하기 편집액션
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = TableViewHelper.createDeleteAction(todoManager: todoManager, tableView: tableView, indexPath: indexPath, date: Date(), vc: self) { success in }
        
        TableViewHelper.configureDeleteActionAppearance(deleteAction)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension TodayTodoViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension TodayTodoViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        print("performDropWith")
    }
}
