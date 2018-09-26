//
//  ViewController.swift
//  JXBarragePanel
//
//  Created by zl on 2018/9/25.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let dataSource = ["text only barrage", "custom barrage"]
    var tableView: UITableView!
    
    //MARK: life cycle
    func setupTableView() {
        tableView = UITableView.init(frame: view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupTableView()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(TextOnlyBarrageController(), animated: true)
        case 1:
            navigationController?.pushViewController(CustomBarrageController(), animated: true)
        default:
            print("not be execute")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

