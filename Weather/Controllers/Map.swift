//
//  Map.swift
//  Weather
//
//  Created by Ky Nguyen Coinhako on 3/20/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit
import GoogleMaps
//import GoogleMapsCore
import GooglePlaces

class weaMapController: knCustomTableController {
    
    var didSelectLocation: ((_ location: knLocationData, _ address: String) -> Void)?
    var datasource = [(placeId: String?, address: String)]()
    lazy var locationManager : CLLocationManager = {
        let location = CLLocationManager()
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.requestWhenInUseAuthorization()
        return location
    }()
    
    lazy var searchTextField: UITextField = { [weak self ] in
        
        let tf = knUIMaker.makeTextField(font: UIFont.systemFont(ofSize: 15),
                                          color: UIColor.color(value: 25))
        tf.backgroundColor = .white
        tf.createRoundCorner(10)
        tf.createBorder(1, color: UIColor.color(value: 191))
        tf.height(40)
        tf.delegate = self
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 40))
        tf.leftView = view
        tf.leftViewMode = .always
        
        let locationButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 40))
        locationButton.setImage(UIImage(named: "location"), for: .normal)
        locationButton.addTarget(self, action: #selector(handleDetectLocation), for: .touchUpInside)
        
        tf.rightView = locationButton
        tf.rightViewMode = .always
        return tf
        }()
    
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        locationManager.startUpdatingLocation()
        searchTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hideBar(true)
    }
    
    override func setupView() {
        navigationController?.hideBar(true)
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: UIScreen.main.bounds, camera: camera)
        view = mapView
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        
        let historyButton = knUIMaker.makeButton(title: "History", font: UIFont.systemFont(ofSize: 15))

        view.addSubviews(views: historyButton, tableView, searchTextField)
        
        historyButton.top(toView: tableView)
        historyButton.centerX(toView: view)
        historyButton.addTarget(self, action: #selector(handleViewHistory))
        
        searchTextField.horizontal(toView: view, space: padding)
        searchTextField.top(toView: view, space: 60)
        
        tableView.horizontal(toView: searchTextField)
        tableView.verticalSpacing(toView: searchTextField, space: 8)
        tableView.height(200)
        tableView.backgroundColor = .color(value: 249)
        
        let button = knUIMaker.makeButton()
        view.addSubview(button)
        button.fill(toView: searchTextField)
        button.addTarget(self, action: #selector(handleActivateTextField))
        
        
    }
    
    @objc func handleActivateTextField() {
        searchTextField.becomeFirstResponder()
    }
    
    @objc func handleViewHistory() {
        push(weaHistoryController())
    }
    
    override func registerCells() {
        tableView.register(ogeLocationCell.self, forCellReuseIdentifier: "ogeLocationCell")
    }
    
}

extension weaMapController {

    @objc func handleDetectLocation() {
        let isLocationOn = CLLocationManager.locationServicesEnabled()
        if isLocationOn {
            checkLocationStatus()
        }
        else {
            showMesage("Please allow us to access to you current location in Setting", title: "Location service is off")
        }
    }
    
    func checkLocationStatus() {
        let locationStatus = CLLocationManager.authorizationStatus()
        
        switch locationStatus {
        case .restricted, .denied:
            showMesage("We need access to location service to get your current location. Please go to Setting and allow it", title: "Location service is restricted")
            
        case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
            locationManager.startUpdatingLocation()
        }
    }
    
    func showMesage(_ message: String, title: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        present(controller, animated: true)
    }
    
    @objc func handleSearch(searchText: String) {
        func didGetPlaces(data: [GMSAutocompletePrediction]) {
            let places = data.map({ return (placeId: $0.placeID, address: $0.attributedFullText.string) })
            datasource = places
            tableView.reloadData()
        }
        
        let placesClient = GMSPlacesClient()
        
        placesClient.autocompleteQuery(searchText, bounds: nil, filter: nil) {(data, _) in
            guard let data = data else { return }
            didGetPlaces(data: data)
        }
    }
    
    func drawApproximateRange(center: CLLocationCoordinate2D) {
        let circ = GMSCircle(position: center, radius: 700)
        circ.fillColor = UIColor(red: 0.1, green: 0, blue: 0, alpha: 0.1)
        circ.strokeColor = .clear
        
        mapView = view as? GMSMapView
        circ.map = mapView
        mapView?.animate(toLocation: center)
        mapView?.animate(toZoom: 15)
    }
    
    func dropPinOnMap(at location: CLLocationCoordinate2D, address: String) {
        let mapView = view as? GMSMapView
        mapView?.animate(toLocation: location)
        mapView?.animate(toZoom: 14)
        let pin = GMSMarker(position: location)
        pin.appearAnimation = GMSMarkerAnimation.pop
        pin.title = address
        pin.snippet = "Your place"
        pin.map = view as? GMSMapView
    }
    
}

extension weaMapController: UITextFieldDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        func updateUIOnGetLocation(likelihood: GMSPlaceLikelihood) {
            searchTextField.text = likelihood.place.formattedAddress
            dropPinOnMap(at: likelihood.place.coordinate, address: likelihood.place.formattedAddress!)
        }
        
        let placesClient = GMSPlacesClient()
        placesClient.currentPlace(callback: { (places, error) in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            guard let places = places else { return }
            for likelihood in places.likelihoods {
                updateUIOnGetLocation(likelihood: likelihood)
                break
            }
        })
        
    }
    
    func returnPlace(_ place: GMSPlace) {
        let location = knLocationData(lat: place.coordinate.latitude, long: place.coordinate.longitude)
        didSelectLocation?(location, place.formattedAddress == nil ? "" : place.formattedAddress!)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableView.isHidden = textField.text == ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        tableView.isHidden = false
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(handleSearch), with: newText, afterDelay: 0.5)
        
        return true
    }
    
}

extension weaMapController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let controller = weaWeatherDetailController()
        controller.locationData = knLocationData(lat: marker.position.latitude,
                                                 long: marker.position.longitude)
        push(controller)
        searchTextField.resignFirstResponder()
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        dropPinOnMap(at: coordinate, address: "")
        searchTextField.resignFirstResponder()
    }
}

extension weaMapController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ogeLocationCell", for: indexPath) as! ogeLocationCell
        cell.data = datasource[indexPath.row].address
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let placesClient = GMSPlacesClient()
        
        guard let id = datasource[indexPath.row].placeId else { return }
        placesClient.lookUpPlaceID(id, callback: { [weak self] place, error in
            self?.searchTextField.text = place?.formattedAddress
            self?.dropPinOnMap(at: place!.coordinate, address: place!.formattedAddress!)
            self?.tableView.isHidden = true
        })
    }
    
}


class ogeLocationCell: knTableCell {
    
    var data: String? { didSet { nameLabel.text = data } }
    
    private let nameLabel = knUIMaker.makeLabel(font: UIFont.systemFont(ofSize: 15),
                                                 color: UIColor.color(value: 25))
    
    override func setupView() {
        
        backgroundColor = UIColor.color(value: 249)
        
        addSubview(nameLabel)
        nameLabel.horizontal(toView: self, space: 23)
        nameLabel.centerY(toView: self)
        
        
        let line = knUIMaker.makeLine()
        addSubview(line)
        line.horizontal(toView: self)
        line.bottom(toView: self)
    }
    
}



























