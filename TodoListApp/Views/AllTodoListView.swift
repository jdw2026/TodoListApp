//
//  AllTodoListView.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/07/02.
//

import UIKit

final class AllTodoListView: UIView {
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["전체" , "미완료" ])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    

    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = .clear
        tv.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoTableViewCell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var tableViewBottomAnchorConstraint = tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
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
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableViewBottomAnchorConstraint
//            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
    }
    
    
    func createSectionHeaderView(withTitle title: String) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
            let button = UIButton()
            button.setImage(UIImage(systemName: "trash"), for: .normal)
            button.tintColor = .black
            button.backgroundColor = .clear
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
            button.translatesAutoresizingMaskIntoConstraints = false
        
        
        headerView.addSubview(label)
        headerView.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            button.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            button.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    
    func createSectionFooterView() -> UIView {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .black
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.addSubview(button)
        
        NSLayoutConstraint.activate([
            footerView.heightAnchor.constraint(equalToConstant: 60),
            button.heightAnchor.constraint(equalToConstant: 25),
            button.widthAnchor.constraint(equalToConstant: 25),
//            button.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 10),
            button.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            button.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 15)
            
        ])
        
        return footerView
    }
    
}
