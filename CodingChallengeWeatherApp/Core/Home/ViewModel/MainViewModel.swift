//
//  MainViewModel.swift
//  CodingChallengeWeatherApp
//
//  Created by Fahad Saleem on 8/29/24.
//

import Foundation

final class CurrentWeatherViewModel {
    private let networking: CurrentWeatherNetworkingProtocol
    weak var delegate: CurrentWeatherViewModelDelegate?
    private(set) var currentWeather: ParseCurrentWeather?
    private(set) var latitude: String?
    private(set) var longitude: String?
    
    init(networking: CurrentWeatherNetworkingProtocol) {
        self.networking = networking
    }
    
    func fetchCurrentWeather() {
        ///If i had more time, would have liked to deal with state Preservation and Restoration instead of using User Defaults
        ///To check for saved Lat and Long and get weather for that
        let coords = alreadyHasCoordinates()
        print("Coords are: \(coords)")
        guard let lat = coords.lat, let lon = coords.lon else { return }
        
        networking.fetchCurrentWeather(lat: lat, lon: lon) { [weak self] result in
            switch result {
            case .success(let currentWeather):
                self?.currentWeather = currentWeather
                DispatchQueue.main.async {
                    self?.delegate?.weatherFetched(data: currentWeather)
                }
            case .failure(let err):
                self?.delegate?.weatherFetchFailure(err: err)
            }
        }
    }
    
    func alreadyHasCoordinates() -> (lat: String?, lon: String?) {
        let defaults = UserDefaults.standard
        let lat = defaults.value(forKey: "latitude") as? String
        let long = defaults.value(forKey: "longitude") as? String
        return (lat, long)
    }
}
