//
//  URLs.swift
//  WeatherAppProject
//
//  Created by Fahad Saleem on 8/29/24.
//

import Foundation

final class URLs {
    static let baseUrl = "https://api.openweathermap.org/"
    static let baseImgUrl = "https://openweathermap.org/img/wn/10d@2x.png"
    
    struct GeocodingUrls {
        static let directGeoCodingUrl = URLs.baseUrl + "geo/1.0/direct"
        static let zipCodeGeoCodingUrl = URLs.baseUrl + "geo/1.0/zip"
        static let reverseGeoCodingUrl = URLs.baseUrl + "geo/1.0/reverse"
    }
    
    struct CurrentWeatherUrls {
        static let currentWeatherUrl = URLs.baseUrl + "data/2.5/weather"
    }
}
