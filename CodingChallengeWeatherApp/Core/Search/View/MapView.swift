//
//  MapView.swift
//  CodingChallengeWeatherApp
//
//  Created by Fahad Saleem on 8/29/24.
//

import MapKit
import SwiftUI

struct MapView: View {
    var sendDataBack: ((ParseRootGeocoderData) -> ())?
    @State private var coordinates = CLLocationCoordinate2D.currentCoordinates
    @State private var position = MapCameraPosition.automatic
    @State private var isSheetPresented: Bool = true
    
    var body: some View {
        ///Given more time, i would have liked to move the marker to the new
        ///Selected locations Latitude and Longitude to reflect upon the change according to search results
        Map(position: $position) {
            Marker("Current Location", coordinate: $coordinates.wrappedValue)
        }
            .ignoresSafeArea()
            .mapStyle(.hybrid(elevation: .realistic))
            .sheet(isPresented: $isSheetPresented, content: {
                SheetView(coordinates: $coordinates, isSheetPresented: $isSheetPresented, geoCoderViewModel: .make())
            })
    }
}

#Preview {
    MapView()
}

extension CLLocationCoordinate2D {
  // Some place in Miami
    static let currentCoordinates = CLLocationCoordinate2D(
        latitude: Double(UserDefaults.standard.value(forKey: "latitude") as? String ?? "0.0") ?? 0.0,
        longitude: Double(UserDefaults.standard.value(forKey: "longitude") as? String ?? "0.0") ?? 0.0)
}
