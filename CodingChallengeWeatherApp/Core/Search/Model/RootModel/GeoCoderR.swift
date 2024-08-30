//
//  GeoCoderR.swift
//  CodingChallengeWeatherApp
//
//  Created by Fahad Saleem on 8/29/24.
//

import Foundation

struct ParseRootGeocoderData: Codable {
    let name: String
    let localNames: LocalNames?
    let lat, lon: Double
    let country: String
    let state: String?

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
    
    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)
        do { self.localNames = try values.decode(LocalNames.self, forKey: .localNames) } catch { self.localNames = nil }
        self.lat = try values.decode(Double.self, forKey: .lat)
        self.lon = try values.decode(Double.self, forKey: .lon)
        self.country = try values.decode(String.self, forKey: .country)
        do { self.state = try values.decode(String.self, forKey: .state) } catch { self.state = nil }
    }
    
    init(name: String, localNames: LocalNames?, lat: Double, lon: Double, country: String, state: String) {
        self.name = name
        self.localNames = localNames
        self.lat = lat
        self.lon = lon
        self.country = country
        self.state = state
    }
}

// MARK: - LocalNames
struct LocalNames: Codable {
    let featureName: String
    
    enum CodingKeys: String, CodingKey {
        case featureName = "feature_name"
    }
}

typealias RootGeoCoderData = [ParseRootGeocoderData]

