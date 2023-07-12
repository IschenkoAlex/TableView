//
//  ViewController.swift
//  TableView
//
//  Created by Alexander Ischenko on 10.07.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Constants and variables
    let tableView = UITableView()
    let identifire = "MyCell"
    private lazy var data: Array<State> = {
        let array = Array(1...30)
        return array.map { State(content: $0.description) }
    }()
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationButtonShuffle()

    }
    
    //MARK: - Private Methods
    private func setupTableView() {
        view.addSubview(tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifire)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupNavigationButtonShuffle() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Shuffle", style: .plain, target: self, action: #selector(pressButtonShuffle))
        
    }
            
    @objc func pressButtonShuffle() {
        let shuffledData = data.shuffled()
        
        tableView.beginUpdates()
        
            for (currentRow, currentValue) in data.enumerated() {
                let toRow = shuffledData.firstIndex(of: currentValue) ?? 0
                tableView.moveRow(at: IndexPath(row: currentRow, section: 0), to: IndexPath(row: toRow, section: 0))
            }
        data = shuffledData
        
        tableView.endUpdates()
   
    }
    // MARK: - TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifire, for: indexPath)
        cell.textLabel?.text = data[indexPath.row].content
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.accessoryType = data[indexPath.row].isSelected ? .checkmark : .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        data[indexPath.row].isSelected.toggle()
        
        guard let  cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
        if cell.accessoryType == .checkmark {
            let value = data.remove(at: indexPath.row)
            data.insert(value, at: 0)
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        }
    }
    
}
class TableViewCell: UITableViewCell {

}

struct State: Equatable {
    var content: String
    var isSelected: Bool = false
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.content == rhs.content
    }
}

