//
//  WishStoringViewController.swift
//  mmvanurinaPW2
//
//  Created by Maria Vanurina on 04.12.2023.
//

import UIKit

protocol AddWishCellDelegate: AnyObject {
    func saveWishArray()
}

final class WishStoringViewController: UIViewController, UITableViewDelegate, AddWishCellDelegate {
    
    private let table: UITableView = UITableView(frame: .zero)
    private let defaults = UserDefaults.standard
    private var wishArray: [String] = ["Я хочу, чтобы декабрь закончился", "Хочу много спать"]
    
    enum Constants {
        static let tableOffset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        static let tableCornerRadius: CGFloat = 20
        static let numberOfSections = 2
    }
    
    private func configureTable() {
        view.addSubview(table)
        table.backgroundColor = .systemPink
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.tableCornerRadius
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        table.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseId)
        table.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseId)
        
        
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 100
        
        
    }
    
    private func loadWishArray() {
        if let storedWishArray = defaults.stringArray(forKey: "WishArrayKey") {
            wishArray = storedWishArray
        }
    }
    
    func saveWishArray() {
        defaults.set(wishArray, forKey: "WishArrayKey")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        configureUI()
        loadWishArray()
        
    }
    
    final class WrittenWishCell: UITableViewCell {
        static let reuseId: String = "WrittenWishCell"
        
        private enum Constants {
            static let wrapColor: UIColor = .white
            static let wrapRadius: CGFloat = 16
            static let wrapOffsetV: CGFloat = 5
            static let wrapOffsetH: CGFloat = 10
            static let wishLabelOffset: CGFloat = 8
        }
        
        private let wishLabel: UILabel = UILabel()
        
        //Lifecycle
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            configureUI()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(with wish: String) {
            wishLabel.text = wish
        }
        
        private func configureUI() {
            selectionStyle = .none
            backgroundColor = .clear
            let wrap: UIView = UIView()
            addSubview(wrap)
            wrap.backgroundColor = Constants.wrapColor
            wrap.layer.cornerRadius = Constants.wrapRadius
            wrap.pinVertical(to: self, Constants.wrapOffsetV)
            wrap.pinHorizontal(to: self, Constants.wrapOffsetH)
            wrap.addSubview(wishLabel)
            wishLabel.pin(to: wrap, Constants.wishLabelOffset)
        }
    }
    
    final class AddWishCell: UITableViewCell {
        static let reuseId: String = "AddWishCell"
        
        private let textView: UITextView = UITextView()
        private let addButton: UIButton = UIButton(type: .system)
        
        var addWish: ((String) -> ())?
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            configureUI()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configureUI() {
                    selectionStyle = .none
                    contentView.addSubview(textView)
                    contentView.addSubview(addButton)
                    
                    textView.backgroundColor = .lightGray
                    textView.layer.cornerRadius = 8
                    textView.isEditable = true
                    textView.translatesAutoresizingMaskIntoConstraints = false
                    
                    addButton.setTitle("Add Wish", for: .normal)
                    addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
                    addButton.translatesAutoresizingMaskIntoConstraints = false
                    addButton.isUserInteractionEnabled = true
                    addButton.backgroundColor = .green
                    
                    NSLayoutConstraint.activate([
                        textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                        textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                        textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                        textView.heightAnchor.constraint(equalToConstant: 30),
                        
                        addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                        addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                        addButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8),
                        addButton.heightAnchor.constraint(equalToConstant: 30),
                        
                        contentView.bottomAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 8)
                    ])
                }
        
        @objc private func addButtonTapped() {
            print("Tap")
            guard let wishText = textView.text, !wishText.isEmpty else { return }
            addWish?(wishText)
            textView.text = ""
        }
    }
    
    private func configureUI() {
        configureTable()
    }
}

// MARK: - UITableViewDataSource
extension WishStoringViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return wishArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddWishCell.reuseId, for: indexPath) as! AddWishCell
                    cell.addWish = { [weak self] wishText in
                        self?.wishArray.append(wishText)
                        self?.saveWishArray()
                        tableView.reloadData()
                    }
                    
                    return cell
                } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.reuseId, for: indexPath) as! WrittenWishCell
            cell.configure(with: wishArray[indexPath.row])
            return cell
        }
    }
}
