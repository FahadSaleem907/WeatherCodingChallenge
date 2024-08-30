//
//  DoubleExtension.swift
//  CodingChallengeWeatherApp
//
//  Created by Fahad Saleem on 8/29/24.
//

import Foundation

extension Double {
    var stringValueWholeNumber: String {
        "\(Int(self))"
    }
    var stringValue: String {
        "\(self)"
    }
}

extension Int {
    var stringValue: String {
        "\(self)"
    }
}
