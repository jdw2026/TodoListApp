//
//  AddTodoViewController.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/06/19.
//

import UIKit

final class AddTodoViewController: UIViewController {
    
    private let addTodoView = AddTodoView()
    private let calendarTodoView = CalendarTodoView()
    let todoManager = CoreDataManager.shared
    var specificDateData: [TodoData] = []
    var calendarDate: Date? = nil
    var safeAreaBottomInset: CGFloat = 0
    
    override func loadView() {
        self.view = addTodoView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("ModalDismissed"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonAction()
        createDatePicker()
        setUI()
        setupNotification()
        addTodoView.dateTextField.delegate = self
        addTodoView.tableView.delegate = self
        addTodoView.tableView.dataSource = self
        addTodoView.tableView.dragInteractionEnabled = true
        addTodoView.tableView.dragDelegate = self
        addTodoView.tableView.dropDelegate = self
        
        //touchesBegan 이 먹히지 않아 제스처 추가
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //키보드 올라갔을때 키보드와 테이블뷰 사이 뜨는 공간
        safeAreaBottomInset = view.safeAreaInsets.bottom
    }
    
    func setupButtonAction() {
        addTodoView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        addTodoView.footerTodoPlusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        addTodoView.allDeleteButton.addTarget(self, action: #selector(allDeleteButtonTapped), for: .touchUpInside)
    }
    
    func createDatePicker() {
        addTodoView.dateTextField.inputView = addTodoView.datePickerContainerView
        addTodoView.dateTextField.inputAccessoryView = createToolbar()
    }
    
    func createToolbar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.sizeToFit()
        toolBar.contentMode = .scaleToFill
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonTapped))
        doneButton.tintColor = .black
        toolBar.setItems([doneButton], animated: true)
        return toolBar
    }
    
    func setUI() {
        if calendarDate == nil {
            addTodoView.titleLabel.text = "새로운 할 일"
        } else {
            guard let date = calendarDate else { return }
            setupData(date: date)
            
            //데이터가 있으면 수정하기, 데이터가 없으면 일정 추가하기
            if specificDateData.first?.todoDate != nil {
                addTodoView.titleLabel.text = "할 일 수정"
            } else {
                addTodoView.titleLabel.text = "새로운 할 일"
            }
            addTodoView.datePicker.date = date
            addTodoView.dateTextField.text = DateHelper.dateFormat(date: date)
            addTodoView.tableView.reloadData()
        }
    }
    
    func setupData(date: Date) {
        specificDateData = todoManager.getParticularTodoData(date: date)
    }
    
    //노티피케이션 셋팅
    func setupNotification() {
        setupKeyboardNotifications(showSelector: #selector(moveUpAction), hideSelector: #selector(moveDownAction))
    }
    
    @objc func moveUpAction(notification: NSNotification) {
        adjustForKeyboard(notification: notification, tableView: addTodoView.tableView, bottomConstraint: addTodoView.tableViewBottomAnchorConstraint, safeAreaBottomInset: safeAreaBottomInset, vc: self)
    }
    
    @objc func moveDownAction() {
        resetAfterKeyboardDismiss(tableView: addTodoView.tableView, bottomConstraint: addTodoView.tableViewBottomAnchorConstraint)
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func plusButtonTapped() {
        if addTodoView.dateTextField.text != "" {
            let selectDate = addTodoView.datePicker.date
            TodoHelper.makeNewTodo(todoManager: todoManager, date: selectDate, vc: self, section: 0, tableView: addTodoView.tableView)
        }
    }
    
    @objc func doneButtonTapped() {
        let date = addTodoView.datePicker.date
        addTodoView.dateTextField.text = DateHelper.dateFormat(date: date)
        setupData(date: date)
        addTodoView.tableView.reloadData()
        self.view.endEditing(true)
    }
    
    //⭐️ 테이블뷰, 스크롤뷰에서 터치 이벤트가 안먹힘... 따로 제스처 추가로 해결 아래 코드 handleTap 메서드로...
    @objc func handleTap(sender: UITapGestureRecognizer) {
        handleTap(sender: sender, tableView: addTodoView.tableView, footerButtonTag: [100], uiView: addTodoView, vc: self)
    }
    
    @objc func allDeleteButtonTapped() {
            let date = addTodoView.datePicker.date
            if todoManager.getParticularTodoData(date: date).count > 0 {
                AlerHelper.showAlertController(date: date, vc: self, todoManager: todoManager, uiView: addTodoView)
                setupData(date: date)
            }
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    
}


extension AddTodoViewController: UITextFieldDelegate {
    
    //캘린더뷰에서 들어왔을경우 날짜 변경 막기
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if calendarDate != nil {
            return false
        }
        return true
    }
    
}

extension AddTodoViewController: UITableViewDelegate  {
    // 셀 밀어서 삭제하기 편집액션
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let date = self.addTodoView.datePicker.date
        let deleteAction = TableViewHelper.createDeleteAction(todoManager: todoManager, tableView: tableView, indexPath: indexPath, date: date, vc: self) { errSecSuccess in }
        
        TableViewHelper.configureDeleteActionAppearance(deleteAction)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension AddTodoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = specificDateData
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addTodoView.tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        
        cell.todoData = specificDateData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //테이블뷰 셀 이동 메서드
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        //움직이는 셀의 데이터 임시저장
        var data = specificDateData
        guard let todoDate = data.first?.todoDate else { return }
        let moveData = data[sourceIndexPath.row]
        //데이터에서 지우고 옮긴 인덱스에 넣어주기
        data.remove(at: sourceIndexPath.row)
        data.insert(moveData, at: destinationIndexPath.row)
        //모든 데이터의 인덱스번호 업데이트후 코어데이터에도 변경사항 저장
        for (index, todoData) in data.enumerated() {
            todoData.order = Int64(index)
            todoManager.todoOrderChangeUpdate(data: todoData, date: todoDate , destinationOrder: Int64(index))
        }
        setupData(date: addTodoView.datePicker.date)
        tableView.reloadData()
    }
}

extension AddTodoViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension AddTodoViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        print("performDropWith")
    }
}

