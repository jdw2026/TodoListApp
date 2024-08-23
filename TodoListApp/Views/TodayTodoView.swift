//
//  TodayTodoView.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/06/20.
//

import UIKit

final class TodayTodoView: UIView {
    
    let tableHeader = UIView()
    
    var dateTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .clear
        label.font = UIFont.boldSystemFont(ofSize: 23)
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
    
    lazy var allDeleteButton: UIButton = {
        let button = UIButton(frame: tableFooterView.bounds)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .clear
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
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
        self.addSubview(tableView)
        
        tableFooterView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 50)
        tableFooterView.addSubview(footerTodoPlusButton)
        tableView.tableFooterView = tableFooterView
        
        tableHeader.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 50)
        tableHeader.addSubview(dateTextLabel)
        tableHeader.addSubview(allDeleteButton)
        tableView.tableHeaderView = tableHeader
        
        dateTextLabel.text = DateHelper.dateFormat(date: Date())
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            dateTextLabel.heightAnchor.constraint(equalToConstant: 50),
            dateTextLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 15),
            dateTextLabel.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -15),
            tableHeader.centerYAnchor.constraint(equalTo: tableHeader.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0),
//            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -216)
            tableViewBottomAnchorConstraint
        ])
        
        NSLayoutConstraint.activate([
            footerTodoPlusButton.heightAnchor.constraint(equalToConstant: 25),
            footerTodoPlusButton.widthAnchor.constraint(equalToConstant: 25),
            footerTodoPlusButton.centerYAnchor.constraint(equalTo: tableFooterView.centerYAnchor),
            footerTodoPlusButton.leadingAnchor.constraint(equalTo: tableFooterView.leadingAnchor, constant: 15)
            
        ])
        
        
        NSLayoutConstraint.activate([
            allDeleteButton.centerYAnchor.constraint(equalTo: tableHeader.centerYAnchor),
            allDeleteButton.trailingAnchor.constraint(equalTo: tableHeader.trailingAnchor, constant: -15)
        ])

    }
    
    
    

    

    
}
