//
//  WeatherCache.swift
//  CodingChallengeWeatherApp
//
//  Created by Fahad Saleem on 8/29/24.
//

import Foundation

class WeatherCache {
    static let shared = WeatherCache()
    private let cache = NSCache<NSString, NSData>()
    private init() { }
    
    ///If given more time, would have preferred to figure out a place to use Images on
    ///And fetch images to display and cache them using these functions
    func set(_ weather: ParseRootCurrentWeather, forKey key: String) {
        guard let data = try? JSONEncoder().encode(weather) else { return }
        cache.setObject(data as NSData, forKey: key as NSString)
    }
    
    func get(forKey key: String) -> ParseRootCurrentWeather? {
        guard let data = cache.object(forKey: key as NSString) as? Data else { return nil }
        return try? JSONDecoder().decode(ParseRootCurrentWeather.self, from: data)
    }
}
