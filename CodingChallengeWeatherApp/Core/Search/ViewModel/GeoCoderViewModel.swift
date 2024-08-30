//
//  GeoCoderViewModel.swift
//  CodingChallengeWeatherApp
//
//  Created by Fahad Saleem on 8/29/24.
//

import Foundation

final class GeoCoderViewModel: ObservableObject {
    private let networking: GeocodingNetworkingProtocol
    weak var delegate: GeoCodingViewModelDelegate?
    @Published private(set) var geoCoder: ParseRootGeocoderData?
    @Published private(set) var latitude: String?
    @Published private(set) var longitude: String?
    private let locationStorageManager: LocationStorageManager
    
    init(networking: GeocodingNetworkingProtocol, locationStorageManager: LocationStorageManager) {
        self.networking = networking
        self.locationStorageManager = locationStorageManager
    }
    
    func fetchGeoCodedData(searchType: SearchByType, cityName: String? = nil, zipCode: String? = nil, lat: String? = nil, lon: String? = nil, completion: @escaping(_ isSuccess: Bool) -> Void) {
        networking.fetchGeocodedData(searchType: searchType,
                                     cityName: cityName,
                                     zipCode: zipCode,
                                     lat: lat,
                                     lon: lon) { [weak self] result in
            
            switch result {
            case .success(let geoCodedData):
                self?.geoCoder = geoCodedData
                self?.saveCoordinate(latitude: geoCodedData.lat.stringValue, longitude: geoCodedData.lon.stringValue)
                self?.save(city: geoCodedData.name)
                DispatchQueue.main.async {
                    self?.delegate?.geoCoderFetched(data: geoCodedData)
                }
                completion(true)
            case .failure(let err):
                self?.delegate?.geoCoderFailure(err: err)
                completion(false)
            }
        }
    }
    
    func saveCoordinate(latitude: String, longitude: String) {
        locationStorageManager.save(location: LocationStorageManager.Coordinates(latitude: latitude, longitude: longitude))
    }
    
    func save(city: String) {
        locationStorageManager.save(city: city)
    }
}

extension GeoCoderViewModel {
    static func make() -> GeoCoderViewModel {
        return GeoCoderViewModel(networking: GeocodedNetworking(networking: Networking()),
                                 locationStorageManager: LocationStorageManager(storageManager: StorageManager()))
    }
}
