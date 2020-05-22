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
    
    let addressLabel: UILabel = {
        let location = UILabel()
        location.translatesAutoresizingMaskIntoConstraints = false
        location.backgroundColor = .white
        location.textColor = .black
        location.numberOfLines = 0
        location.adjustsFontSizeToFitWidth = true
        location.textAlignment = .center
        location.font = UIFont.init(name: "Quicksand-Bold", size: 20)
        return location
    }()
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 7000
    var previousLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        mapView.addSubview(pointer)
        mapView.addSubview(addressLabel)
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
        
        addressLabel.snp.makeConstraints{(maker) in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.height.equalTo(100)
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
            startTrackingUserLocation()
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
    
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return}
            
            if let _ = error {
                //alert
                return
            }
            
            guard let placemark = placemarks?.first else {
                //alert
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""

            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetName) \(streetNumber)"
            }
        }
    }
}
