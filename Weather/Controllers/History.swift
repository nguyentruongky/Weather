//
//  History.swift
//  Weather
//
//  Created by Ky Nguyen Coinhako on 3/21/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

class weaHistoryController: knCustomTableController {
    
    var datasource = [weaWeatherModel]() { didSet { tableView.reloadData() }}
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hideBar(false)
    }
    
    override func setupView() {
        title = "History"
        view.addSubview(tableView)
        tableView.fill(toView: view)
    }
    
    override func registerCells() {
        tableView.register(weaHistoryCell.self, forCellReuseIdentifier: "weaHistoryCell")
    }
    
    override func fetchData() {
        datasource = weaOfflineStorage.getList()
    }
}

extension weaHistoryController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weaHistoryCell", for: indexPath) as! weaHistoryCell
        let data = datasource[indexPath.row]
        cell.data = data.placeName.or("") + " - " + data.country.or("")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = datasource[indexPath.row]
        let controller = weaWeatherDetailController()
        controller.offlineData = data
        push(controller)
    }
}

class weaHistoryCell: knTableCell {
    var data: String? {
        didSet {
            textLabel?.text = data
        }
    }
    
    override func setupView() {
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.font = UIFont.systemFont(ofSize: 15)
        textLabel?.centerY(toView: self)
        textLabel?.left(toView: self, space: padding)
        
        let line = knUIMaker.makeLine()
        addSubviews(views: line)
        line.horizontal(toView: self)
        line.bottom(toView: self)
    }
}












