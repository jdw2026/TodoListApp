//
//  TodoTableViewCell.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/06/18.
//

import UIKit

final class TodoTableViewCell: UITableViewCell {
    
    lazy var checkBox: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        button.tintColor = .black
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let todoTextFeild: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.textColor = .black
        tf.backgroundColor = .clear
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.returnKeyType = .done
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    var checkBoxButtonPressed: (TodoTableViewCell) -> Void = { (sender) in }
    
    var textFeildEnd: (TodoTableViewCell) -> Void = { (sender) in }
    
    var todoData: TodoData? {
        didSet {
            configureUIwithData()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        setConstraints()
        todoTextFeild.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setConstraints() {

        self.contentView.addSubview(checkBox)
        NSLayoutConstraint.activate([
            checkBox.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            checkBox.widthAnchor.constraint(equalToConstant: 30),
            checkBox.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        self.contentView.addSubview(todoTextFeild)
        NSLayoutConstraint.activate([
            todoTextFeild.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 10),
            todoTextFeild.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            todoTextFeild.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
        
    }
    
    
    func configureUIwithData() {
        
        guard let text = todoData?.todoText else { return }
        
        todoTextFeild.text = text
        checkBox.isSelected = todoData?.checkStatus ?? false
        
        if checkBox.isSelected == true {
            applyCheckMarker()
        } else {
            removeCheckMarker()
        }
    }
    
    
    @objc func checkBoxTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        //체크박스에 체크표시가 없을 경우
        if sender.isSelected == false {
            removeCheckMarker()
            checkBoxButtonPressed(self)
            
        } else { //체크박스에 체크표시가 있을 경우
            applyCheckMarker()
            checkBoxButtonPressed(self)
        }
    }
    
    //체크박스에 체크 표시 했을때
    func applyCheckMarker() {
        
        //텍스트필드 비활성화
        todoTextFeild.isUserInteractionEnabled = false
        
        guard let textFieldText = todoTextFeild.text else { return }
        
        todoData?.todoText = textFieldText
        todoData?.checkStatus = true
        
        //텍스트필드 글씨 취소선 적용
        let attributeString = NSMutableAttributedString(string: textFieldText)
        attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        todoTextFeild.attributedText = attributeString
        
        //글자색 밝은회색으로
        todoTextFeild.textColor = .lightGray
    }
    
    //체크박스에 체크 표시 없을때
    func removeCheckMarker() {
        
        guard let textFieldText = todoTextFeild.text else { return }
        
        let temp = textFieldText
        todoData?.todoText = temp
        todoData?.checkStatus = false
        
        //        취소선 삭제
        let attributeString = NSMutableAttributedString(string: textFieldText)
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        todoTextFeild.attributedText = attributeString
        
        //텍스트필드 활성화시키고 글자색상 블랙으로
        todoTextFeild.textColor = .black
        todoTextFeild.isUserInteractionEnabled = true
    }
}

extension TodoTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        todoData?.todoText = text
        textFeildEnd(self)
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        todoData?.todoText = text
        textFeildEnd(self)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("데이터 오더번호 - ",todoData?.order ?? "---nonono")
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        todoTextFeild.resignFirstResponder()
        return true
    }
    
    
}


