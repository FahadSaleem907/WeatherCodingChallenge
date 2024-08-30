//
//  StorageManager.swift
//  CodingChallengeWeatherApp
//
//  Created by Fahad Saleem on 8/29/24.
//

import CoreLocation
import Foundation

final class StorageManager {
    let defaults = UserDefaults.standard
    
    func update() { }
    
    func save(key: String, value: String) {
        defaults.setValue(value, forKey: key)
    }
    
    func fetch(key: String) -> String? {
        defaults.value(forKey: key) as? String
    }
}

final class LocationStorageManager {
    enum UserDefaultKeys: String {
        case latitude
        case longitude
        case city
    }
    
    struct Coordinates {
        let latitude: String
        let longitude: String
    }
    
    private let storageManager: StorageManager
    
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }
    
    func save(location: Coordinates) {
        print("Saving to UserDefaults: \(location.latitude) and \(location.longitude)")
        storageManager.save(key: UserDefaultKeys.latitude.rawValue, value: "\(location.latitude)")
        storageManager.save(key: UserDefaultKeys.longitude.rawValue, value: "\(location.longitude)")
    }
    
    func save(city: String) {
        storageManager.save(key: UserDefaultKeys.city.rawValue, value: city)
    }
    
    func fetch() -> (lat: String?, lon: String?) {
        let lat = storageManager.fetch(key: UserDefaultKeys.latitude.rawValue)
        let lon = storageManager.fetch(key: UserDefaultKeys.longitude.rawValue)
        
        return (lat, lon)
    }
    
    func exists(key: UserDefaultKeys) -> Bool {
        storageManager.fetch(key: key.rawValue) != nil
    }
}
