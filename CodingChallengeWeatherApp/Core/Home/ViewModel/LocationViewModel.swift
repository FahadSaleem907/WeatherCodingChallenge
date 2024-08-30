//
//  LocationViewModel.swift
//  CodingChallengeWeatherApp
//
//  Created by Fahad Saleem on 8/29/24.
//

import CoreLocation
import Foundation

class LocationViewModel {
    private let locationManager: LocationManager
    
    var currentLocation: ((CLLocation) -> Void)?
    var error: ((Error) -> Void)?
    var authorizationStatus: ((CLAuthorizationStatus) -> Void)?
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        
        locationManager.didChangeAuthorizationStatus = { [weak self] status in
            self?.authorizationStatus?(status)
        }
        
        locationManager.didUpdateLocation = { [weak self] location in
            self?.currentLocation?(location)
        }
        
        locationManager.didFailWithError = { [weak self] error in
            self?.error?(error)
        }
    }
}
