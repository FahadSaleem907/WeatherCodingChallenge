//
//  NetworkingProtocols.swift
//  CodingChallengeWeatherApp
//
//  Created by Kumar Rajesh on 8/29/24.
//

import Foundation

protocol CurrentWeatherNetworkingProtocol {
    func fetchCurrentWeather(lat: String, lon: String, completion: @escaping(Result<ParseCurrentWeather, Error>) -> Void)
}

protocol GeocodingNetworkingProtocol {
    func fetchGeocodedData(searchType: SearchByType, cityName: String?, zipCode: String?, lat: String?, lon: String?, completion: @escaping(Result<ParseRootGeocoderData, Error>) -> Void)
}
