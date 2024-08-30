//
//  CurrentWeather.swift
//  WeatherAppProject
//
//  Created by Fahad Saleem on 8/29/24.
//

import Foundation

struct ParseCurrentWeather {
    let name, main, description, icon: String
    let humidity: Int
    let temp, tempMin, tempMax, wind: Double
    let rain, snow: Double?
}
