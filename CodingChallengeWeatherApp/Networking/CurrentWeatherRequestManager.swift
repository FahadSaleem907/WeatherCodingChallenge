//
//  RequestManager.swift
//  WeatherAppProject
//
//  Created by Fahad Saleem on 8/29/24.
//

import Foundation

///To handle multiple Error types
enum NetworkingError: Error {
    case invalidURL
    case invalidResponse
    case noDataReceived
    case badRequest
    case unauthorized
    case notFound
    case serverError
    case unknownError
}

final class CurrentWeatherNetworking: CurrentWeatherNetworkingProtocol {
    private let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func fetchCurrentWeather(lat: String, lon: String, completion: @escaping (Result<ParseCurrentWeather, Error>) -> Void) {
        guard let url = URL(string: URLs.CurrentWeatherUrls.currentWeatherUrl) else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        var requestComponent = URLComponents(string: url.absoluteString)
        requestComponent?.queryItems = [URLQueryItem(name: "lat", value: lat), URLQueryItem(name: "lon", value: lon), URLQueryItem(name: "appid", value: GlobalConstants().apiKey)]
        let request = URLRequest(url: requestComponent!.url!)
            
        networking.fetchData(from: request, model: ParseRootCurrentWeather.self) { result in
            switch result {
            case .success(let data):
                let currentWeatherData = ParseCurrentWeather(
                    name: data.name,
                    main: data.weather.first?.mainTitle ?? "N/A",
                    description: data.weather.first?.description ?? "N/A",
                    icon: data.weather.first?.icon ?? "N/A",
                    humidity: data.main.humidity,
                    temp: data.main.temp,
                    tempMin: data.main.tempMin,
                    tempMax: data.main.tempMax,
                    wind: data.wind.speed,
                    rain: data.rain?.the1H ?? 0.0,
                    snow: data.snow?.the1H ?? 0.0)
                let result = currentWeatherData
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
