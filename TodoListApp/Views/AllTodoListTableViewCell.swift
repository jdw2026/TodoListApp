//
//  AllTodoListTableViewCell.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/07/02.
//

import UIKit

final class AllTodoListTableViewCell: UITableViewCell {
    
    let tableHeader = UIView()
    
    var dateTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        setupView()
//        tableView.delegate = self
//        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupView() {
        self.addSubview(tableView)
        
        tableFooterView.frame = CGRect(x: 10, y: -15, width: self.bounds.width, height: 50)
        tableFooterView.addSubview(footerTodoPlusButton)
        tableView.tableFooterView = tableFooterView
        
        tableHeader.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 50)
        tableHeader.addSubview(dateTextLabel)
        tableView.tableHeaderView = tableHeader
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            dateTextLabel.heightAnchor.constraint(equalToConstant: 50),
            dateTextLabel.widthAnchor.constraint(equalToConstant: 150),
            dateTextLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 15),
            tableHeader.centerYAnchor.constraint(equalTo: tableHeader.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            footerTodoPlusButton.heightAnchor.constraint(equalToConstant: 50),
            footerTodoPlusButton.widthAnchor.constraint(equalToConstant: 50)
            
        ])
        
        setupButtonConstraints()
        
    }
    
    func setupButtonConstraints() {
        guard let imageView = footerTodoPlusButton.imageView else { return }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 35),
            imageView.widthAnchor.constraint(equalToConstant: 35)
        ])
    }

}

//extension AllTodoListTableViewCell: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//}
//
//extension AllTodoListTableViewCell: UITableViewDelegate {
//
//}
