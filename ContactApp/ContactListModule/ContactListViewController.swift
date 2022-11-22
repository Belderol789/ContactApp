//
//  ViewController.swift
//  ContactApp
//
//  Created by Kem on 11/21/22.
//

import UIKit
import SnapKit
import RxCocoa

class ContactListViewController: UIViewController {
    // MARK: - Views
    private lazy var contactTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
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
        setupUI()
        setupTableView()
        configureBindings()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(18)
        }
        view.addSubview(contactTableView)
        contactTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
        
    }
    // MARK: - Setup Tableview
    private func setupTableView() {
        contactTableView.delegate = self
        contactTableView.dataSource = self
    }
    // MARK: - RxSwift Bindings
    private func configureBindings() {
        self.viewModel.bindContactNames()
        self.viewModel.contacts
            .asDriver()
            .drive(onNext:{ [weak self] contacts in
                self?.contactTableView.reloadData()
            })
            .disposed(by: viewModel.disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension ContactListViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension ContactListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getContactListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = viewModel.getContactNames()[indexPath.row]
        return cell
    }
}

