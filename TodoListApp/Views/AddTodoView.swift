//
//  AddTodoView.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/06/19.
//

import UIKit

final class AddTodoView: UIView {
    
    var datePickerContainerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
        view.backgroundColor = .white
        return view
    }()
    
    var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .inline
        dp.locale = Locale(identifier: "ko-KR")
        dp.backgroundColor = .white
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    var dateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "날짜를 선택해 주세요"
        tf.backgroundColor = .clear
        tf.textColor = .black
        tf.tintColor = .clear
        tf.font = UIFont.boldSystemFont(ofSize: 23)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var allDeleteButton: UIButton = {
        let button = UIButton(frame: tableFooterView.bounds)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [dateTextField, allDeleteButton])
        sv.spacing = 10
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.backgroundColor = .clear
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
   
    var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoTableViewCell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let tableFooterView = UIView()
    
    lazy var footerTodoPlusButton: UIButton = {
        let button = UIButton(frame: tableFooterView.bounds)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .black
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tag = 100
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    lazy var tableViewBottomAnchorConstraint = tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0)
    
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
        
        self.addSubview(closeButton)
        self.addSubview(titleLabel)
//        self.addSubview(dateTextField)
        self.addSubview(stackView)
        self.addSubview(tableView)
        
        
        datePickerContainerView.addSubview(datePicker)
        
        tableFooterView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 50)
        tableFooterView.addSubview(footerTodoPlusButton)
        tableView.tableFooterView = tableFooterView
    }

    
    func setupConstraints() {

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            closeButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            closeButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            dateTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            dateTextField.heightAnchor.constraint(equalToConstant: 50),
            dateTextField.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            allDeleteButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            allDeleteButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            allDeleteButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: datePickerContainerView.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor, constant: 15),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainerView.trailingAnchor, constant: -15),
            datePicker.bottomAnchor.constraint(equalTo: datePickerContainerView.bottomAnchor)
        ])

        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableViewBottomAnchorConstraint
        ])
        
        NSLayoutConstraint.activate([
            footerTodoPlusButton.heightAnchor.constraint(equalToConstant: 30),
            footerTodoPlusButton.widthAnchor.constraint(equalToConstant: 30),
            footerTodoPlusButton.topAnchor.constraint(equalTo: tableFooterView.topAnchor, constant: 10),
            footerTodoPlusButton.leadingAnchor.constraint(equalTo: tableFooterView.leadingAnchor, constant: 15)
        ])
        
        
    }
    

}
