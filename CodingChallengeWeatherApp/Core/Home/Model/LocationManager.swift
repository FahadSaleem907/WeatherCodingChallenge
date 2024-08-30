//
//  LocationManager.swift
//  CodingChallengeWeatherApp
//
//  Created by Fahad Saleem on 8/29/24.
//

import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let locationStoreManager: LocationStorageManager
    var didUpdateLocation: ((CLLocation) -> Void)?
    var didFailWithError: ((Error) -> Void)?
    var didChangeAuthorizationStatus: ((CLAuthorizationStatus) -> Void)?
    
    init(locationStorageManager: LocationStorageManager){
        self.locationStoreManager = locationStorageManager
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        startUpdateLoc()
    }
    
    func startUpdateLoc() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if !locationStoreManager.exists(key: .latitude) {
                print("Got the coords values: \(location.coordinate.latitude.stringValue) and \(location.coordinate.longitude.stringValue)")
                locationStoreManager.save(location: LocationStorageManager.Coordinates(latitude: location.coordinate.latitude.stringValue, longitude: location.coordinate.longitude.stringValue))
            }
            didUpdateLocation?(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didFailWithError?(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        didChangeAuthorizationStatus?(status)
    }
}
