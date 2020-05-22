//
//  MapViewController.swift
//  weather-app
//
//  Created by Miran Hrupački on 22/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: UIViewController {
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    let pointer: UIImageView = {
        let pointer = UIImageView()
        pointer.translatesAutoresizingMaskIntoConstraints = false
        pointer.image = UIImage(named: "pointer")
        pointer.frame = CGRect(x: 0, y: 0, width: 50, height: -20)
        return pointer
    }()
    
    let currentLocation: UILabel = {
        let location = UILabel()
        location.translatesAutoresizingMaskIntoConstraints = false
        location.backgroundColor = .white
        location.textColor = .black
        location.text = "avc"
        location.numberOfLines = 0
        location.adjustsFontSizeToFitWidth = true
        location.textAlignment = .center
        location.font = UIFont.init(name: "Quicksand-Bold", size: 20)
        return location
    }()
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 7000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        mapView.addSubview(pointer)
        mapView.addSubview(currentLocation)
        
        setupUI()
        checkLocationService()
    }
    
    func setupUI() {
        setupConstraints()
    }
    
    func setupConstraints(){
        mapView.snp.makeConstraints{(maker) in
            maker.edges.equalToSuperview()
        }
        
        pointer.snp.makeConstraints{(maker) in
            maker.centerY.equalTo(mapView.snp.centerY)
            maker.centerX.equalTo(mapView.snp.centerX)
        }
        
        currentLocation.snp.makeConstraints{(maker) in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.height.equalTo(50)
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationService() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
