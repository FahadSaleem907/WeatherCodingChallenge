//
//  WeatherProtocols.swift
//  CodingChallengeWeatherApp
//
//  Created by Kumar Rajesh on 8/29/24.
//

import Foundation

protocol CurrentWeatherViewModelDelegate: AnyObject {
    func weatherFetchFailure(err: Error)
    func weatherFetched(data: ParseCurrentWeather)
}
