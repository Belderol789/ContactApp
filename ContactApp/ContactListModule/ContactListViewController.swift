//
//  ViewController.swift
//  ContactApp
//
//  Created by Kem on 11/21/22.
//

import UIKit

class ContactListViewController: UIViewController {
    // MARK: - Views
    private lazy var contactTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "Contacts List"
        label.textColor = .darkGray
        return label
    }()
    // MARK: - Variables
    var viewModel: ContactListViewModel
    
    // MARK: - Init
    required init(viewModel: ContactListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

