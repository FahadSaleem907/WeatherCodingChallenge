//
//  GeoCoderProtocols.swift
//  CodingChallengeWeatherApp
//
//  Created by Kumar Rajesh on 8/29/24.
//

import Foundation

protocol GeoCodingViewModelDelegate: AnyObject {
    func geoCoderFailure(err: Error)
    func geoCoderFetched(data: ParseRootGeocoderData?)
}
