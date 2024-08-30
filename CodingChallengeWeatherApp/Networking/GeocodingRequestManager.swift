//
//  GeocodingRequestManager.swift
//  CodingChallengeWeatherApp
//
//  Created by Fahad Saleem on 8/29/24.
//

import Foundation

final class GeocodedNetworking: GeocodingNetworkingProtocol {
    private let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func fetchGeocodedData(searchType: SearchByType, cityName: String?, zipCode: String?, lat: String?, lon: String?, completion: @escaping (Result<ParseRootGeocoderData, any Error>) -> Void) {
        
        var finalUrl: URL
        var requestComp: URLComponents
        switch searchType {
        case .city:
            guard let url = URL(string: URLs.GeocodingUrls.directGeoCodingUrl) else {
                completion(.failure(NetworkingError.invalidURL))
                return
            }
            finalUrl = url
            requestComp = URLComponents(string: finalUrl.absoluteString)!
            requestComp.queryItems = [URLQueryItem(name: "q", value: cityName),
                                      URLQueryItem(name: "limit", value: "1"),
                                      URLQueryItem(name: "appid", value: GlobalConstants().apiKey)]
        case .zipcode:
            guard let url = URL(string: URLs.GeocodingUrls.zipCodeGeoCodingUrl) else {
                completion(.failure(NetworkingError.invalidURL))
                return
            }
            finalUrl = url
            requestComp = URLComponents(string: finalUrl.absoluteString)!
            requestComp.queryItems = [URLQueryItem(name: "zip", value: zipCode),
                                      URLQueryItem(name: "appid", value: GlobalConstants().apiKey)]
        case .coordinates:
            guard let url = URL(string: URLs.GeocodingUrls.reverseGeoCodingUrl) else {
                completion(.failure(NetworkingError.invalidURL))
                return
            }
            finalUrl = url
            requestComp = URLComponents(string: finalUrl.absoluteString)!
            requestComp.queryItems = [URLQueryItem(name: "lat", value: lat),
                                      URLQueryItem(name: "lon", value: lon),
                                      URLQueryItem(name: "appid", value: GlobalConstants().apiKey)]
        }
        
        let request = URLRequest(url: requestComp.url!)
            
        if searchType == .zipcode {
            networking.fetchData(from: request, model: ParseRootGeocoderData.self) { result in
                switch result {
                case .success(let data):
                    let geoCodedData = data
                    completion(.success(geoCodedData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            networking.fetchData(from: request, model: [ParseRootGeocoderData].self) { result in
                switch result {
                case .success(let data):
                    let geoCodedData = data
                    if !geoCodedData.isEmpty {
                        completion(.success(geoCodedData.first!))
                    } else {
                        completion(.failure(NetworkingError.invalidResponse))
                    }
//                    completion(.success(geoCodedData.first!))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
