//
//  CurrentWeather.swift
//  WeatherAppProject
//
//  Created by Fahad Saleem on 8/29/24.
//

import Foundation

// MARK: - Welcome
struct ParseRootCurrentWeather: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let snow: Snow?
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
    
    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.coord = try values.decode(Coord.self, forKey: .coord)
        self.weather = try values.decode([Weather].self, forKey: .weather)
        self.base = try values.decode(String.self, forKey: .base)
        self.main = try values.decode(Main.self, forKey: .main)
        self.visibility = try values.decode(Int.self, forKey: .visibility)
        self.wind = try values.decode(Wind.self, forKey: .wind)
        do { self.rain = try values.decode(Rain.self, forKey: .rain) } catch { self.rain = nil }
        do { self.snow = try values.decode(Snow.self, forKey: .snow) } catch { self.snow = nil }
        self.clouds = try values.decode(Clouds.self, forKey: .clouds)
        self.dt = try values.decode(Int.self, forKey: .dt)
        self.sys = try values.decode(Sys.self, forKey: .sys)
        self.timezone = try values.decode(Int.self, forKey: .timezone)
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        self.cod = try values.decode(Int.self, forKey: .cod)
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let mainTitle, description, icon: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case mainTitle = "main"
        case description, icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
    
    enum CodingKeys: String, CodingKey {
        case speed,deg,gust
    }
    
    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.speed = try values.decode(Double.self, forKey: .speed)
        self.deg = try values.decode(Int.self, forKey: .deg)
        do { self.gust = try values.decode(Double.self, forKey: .gust) } catch { self.gust = nil }
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Snow
struct Snow: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}
