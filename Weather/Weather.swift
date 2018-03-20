//
//  Weather.swift
//  Weather
//
//  Created by Ky Nguyen Coinhako on 3/20/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

class weaWeatherDetailController: knCustomTableController {
    
    var datasource = [knTableCell]() { didSet { tableView.reloadData() }}
    var locationData: knLocationData? {
        didSet {
            fetchData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func setupView() {
        view.addSubview(tableView)
        tableView.fill(toView: view)
        
        navigationController?.hideBar(false)
    }
    
    override func fetchData() {
        guard let data = locationData else { return }
        weaGetWeatherWorker(lat: data.lat, long: data.long, successResponse: didFetchWeatherSuccess, failResponse: didFetchWeatherFail).execute()
    }
    
    func didFetchWeatherSuccess(weather: weaWeatherModel) {
        var cells = [knTableCell]()
        if let data = weather.placeName {
            cells.append(makeTitleCell(data, fontSize: 20))
        }
        
        cells.append(makeTitleCell(String(weather.temp), fontSize: 50))
        
        if let data = weather.weather {
            cells.append(makeDetailCell(title: "Weather", value: data))
        }
        
        if let data = weather.weatherDesc {
            cells.append(makeDetailCell(title: "", value: data.capitalizingFirstLetter()))
        }
        
        cells.append(makeDetailCell(title: "Min temp", value: String(weather.tempMin)))
        cells.append(makeDetailCell(title: "Max temp", value: String(weather.tempMax)))
        cells.append(makeDetailCell(title: "Humidity", value: String(weather.humidity)))
        
        datasource = cells
    }
    
    func makeTitleCell(_ title: String, fontSize: CGFloat) -> knTableCell {
        
        let cell = knTableCell()
        let titleLabel = knUIMaker.makeLabel(font: UIFont.boldSystemFont(ofSize: fontSize),
                                               color: .color(value: 60), text: title)
        titleLabel.textAlignment = .center
        cell.addSubview(titleLabel)
        titleLabel.fill(toView: cell, space: UIEdgeInsets(top: 18, left: 0, bottom: 8, right: 0))
        
        return cell
    }
    
    func makeDetailCell(title: String, value: String) -> knTableCell {
        let cell = knTableCell()
        let titleLabel = knUIMaker.makeLabel(font: UIFont.boldSystemFont(ofSize: 15),
                                               color: .color(value: 180),
                                               text: title)
        let valueLabel = knUIMaker.makeLabel(font: UIFont.systemFont(ofSize: 15),
                                               color: .color(value: 60),
                                               text: value)
        let line = knUIMaker.makeLine(color: .color(value: 230))
        
        cell.addSubviews(views: titleLabel, valueLabel, line)
        titleLabel.left(toView: cell, space: padding)
        titleLabel.vertical(toView: cell, space: padding)
        titleLabel.horizontalSpacing(toView: valueLabel, space: padding)
        
        valueLabel.right(toView: cell, space: -padding)
        valueLabel.centerY(toView: cell)
        valueLabel.lineBreakMode = .byTruncatingTail
        
        line.bottom(toView: cell)
        line.horizontal(toView: cell, space: padding)
        
        return cell
    }
    
    func didFetchWeatherFail(err: knError) {
        
    }
}

extension weaWeatherDetailController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return datasource[indexPath.row] }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64 }
}


