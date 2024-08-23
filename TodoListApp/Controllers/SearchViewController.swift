//
//  SearchViewController.swift
//  TodoListApp
//
//  Created by 정다운 on 2024/06/19.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private let searchView = SearchView()
    
    override func loadView() {
        self.view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


}
