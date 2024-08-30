//
//  SheetView.swift
//  CodingChallengeWeatherApp
//
//  Created by Fahad Saleem on 8/29/24.
//

import CoreLocation
import SwiftUI

enum SearchByType: String, CaseIterable {
    case city = "city"
    case zipcode = "zipcode"
    case coordinates = "coordinates"
}

struct SheetView: View {
    @Binding var coordinates: CLLocationCoordinate2D
    @Binding var isSheetPresented: Bool
    @State private var errorMsg: String = ""
    @State private var searchingType: SearchByType = .city
    @State private var searchByCityName: String = ""
    @State private var searchByZipCode: String = ""
    @State private var searchByLatitude: String = ""
    @State private var searchByLongitude: String = ""
    private let geoCoderViewModel: GeoCoderViewModel
    
    init(coordinates: Binding<CLLocationCoordinate2D>, isSheetPresented: Binding<Bool>, geoCoderViewModel: GeoCoderViewModel) {
        _coordinates = coordinates
        _isSheetPresented = isSheetPresented
        self.geoCoderViewModel = geoCoderViewModel
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Picker("Search By", selection: $searchingType, content: {
                ForEach(SearchByType.allCases, id: \.self) {
                    Text($0.rawValue.capitalized)
                }
            })
            .pickerStyle(.segmented)
            .padding()
            .padding(.bottom, 40)
            
            Text("\(errorMsg)")
            
            SelectedSearch(type: searchingType, searchByCityName: $searchByCityName, searchByZipCode: $searchByZipCode, searchByLatitude: $searchByLatitude, searchByLongitude: $searchByLongitude)

            Button("Search") {
                switch searchingType {
                case .city:
                    geoCoderViewModel.fetchGeoCodedData(searchType: .city,
                                            cityName: $searchByCityName.wrappedValue) { success in
                        if success {
                            isSheetPresented = false
                            coordinates = CLLocationCoordinate2D.currentCoordinates
                            errorMsg = ""
                        } else {
                            errorMsg = "Failed to get data"
                        }
                    }
                case .zipcode:
                    geoCoderViewModel.fetchGeoCodedData(searchType: .zipcode,
                                            zipCode: $searchByZipCode.wrappedValue) { success in
                        if success {
                            isSheetPresented = false
                            coordinates = CLLocationCoordinate2D.currentCoordinates
                            errorMsg = ""
                        } else {
                            errorMsg = "Failed to get data"
                        }
                    }
                case .coordinates:
                    geoCoderViewModel.fetchGeoCodedData(searchType: .coordinates,
                                            lat: $searchByLatitude.wrappedValue,
                                            lon: $searchByLongitude.wrappedValue) { success in
                        if success {
                            isSheetPresented = false
                            coordinates = CLLocationCoordinate2D.currentCoordinates
                            errorMsg = ""
                        } else {
                            errorMsg = "Failed to get data, enter correct latitude and longitude"
                        }
                    }
                }
            }
        }
        .padding()
        .interactiveDismissDisabled()
        .presentationDetents([.height(300), .large])
        .presentationBackground(.regularMaterial)
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
    }
    
}

struct TextFieldGrayBackgroundColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundStyle(.primary)
    }
}

//#Preview {
//    SheetView(isSheetPresented: ,
//              geoCoderViewModel: <#GeoCoderViewModel#>)
//}

struct SearchField: View {
    var placeHolder: String
    @Binding var search: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField(placeHolder, text: $search)
                .autocorrectionDisabled()
        }
        .modifier(TextFieldGrayBackgroundColor())
    }
}

struct SelectedSearch: View {
    var type: SearchByType
    @Binding var searchByCityName: String
    @Binding var searchByZipCode: String
    @Binding var searchByLatitude: String
    @Binding var searchByLongitude: String
    
    var body: some View {
        switch type {
        case .city:
            SearchField(placeHolder: "Search for weather by City Name", search: $searchByCityName)
        case .zipcode:
            SearchField(placeHolder: "Search by ZipCode", search: $searchByZipCode)
        case .coordinates:
            SearchField(placeHolder: "Search by Latitude", search: $searchByLatitude)
            SearchField(placeHolder: "Search by Longitude", search: $searchByLongitude)
        }
    }
}

