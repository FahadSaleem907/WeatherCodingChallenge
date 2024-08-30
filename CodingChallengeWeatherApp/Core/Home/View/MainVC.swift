//
//  ViewController.swift
//  CodingChallengeWeatherApp
//
//  Created by Fahad Saleem on 8/29/24.
//

import Combine
import CoreLocation
import SwiftUI
import UIKit

class MainVC: UIViewController {
    //MARK: - ----- Constants -----
    let searchController = UISearchController(searchResultsController: nil)
    ///Set Countries list in viewModel
    private let weatherViewModel: CurrentWeatherViewModel = CurrentWeatherViewModel(networking: CurrentWeatherNetworking(networking: Networking()))
    private let locationViewModel: LocationViewModel = {
        let storageManager = StorageManager()
        let locationStorageManager = LocationStorageManager(storageManager: storageManager)
        let locationManager = LocationManager(locationStorageManager: locationStorageManager)
        
        return LocationViewModel(locationManager: locationManager)
    }()
    
    //MARK: - ----- Variables -----
    var isSearchForName = true
 
    //MARK: ----- Outlets -----
    @IBOutlet weak var btnSearch: UIButton!{
        didSet {
            btnSearch.contentHorizontalAlignment = .fill
            btnSearch.contentVerticalAlignment = .fill
        }
    }
    @IBOutlet weak var locationStatus: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherCondition: UILabel!
    @IBOutlet weak var highestTemperature: UILabel!
    @IBOutlet weak var lowestTemperature: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var humidityView: UIView! {
        didSet {
            humidityView.layer.cornerRadius = 15
            humidityView.layer.borderColor = UIColor.gray.cgColor
            humidityView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var wind: UILabel!
    
    @IBOutlet weak var windView: UIView!{
        didSet {
            windView.layer.cornerRadius = 15
            windView.layer.borderColor = UIColor.gray.cgColor
            windView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var rain: UILabel!
    @IBOutlet weak var rainView: UIView!{
        didSet {
            rainView.layer.cornerRadius = 15
            rainView.layer.borderColor = UIColor.gray.cgColor
            rainView.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var snow: UILabel!
    @IBOutlet weak var snowView: UIView! {
        didSet {
            snowView.layer.cornerRadius = 15
            snowView.layer.borderColor = UIColor.gray.cgColor
            snowView.layer.borderWidth = 1
        }
    }
    
    
    //MARK: ----- Actions -----
    @IBAction func searchBtn(_ sender: UIButton) {
        let swiftUIView = MapView { [weak self] data in
            guard let self = self else { return }
            let lat = data.lat
            let lon = data.lon
            ///If i had more time would have done the proper implementation for this user default handling too
            UserDefaults.standard.setValue("\(lat)", forKey: "latitude")
            UserDefaults.standard.setValue("\(lon)", forKey: "longitude")
            self.weatherViewModel.fetchCurrentWeather()
        }
        let hc = UIHostingController(rootView: swiftUIView)
        navigationController?.pushViewController(hc, animated: true)
    }
    
    
    //MARK: - ----- Functions -----
    func setupData() {
        weatherViewModel.delegate = self
        setupLocBindings()
    }
    
    func setupLocBindings() {
        locationViewModel.currentLocation = {  location in
        }
        
        locationViewModel.error = { error in
            DispatchQueue.main.async {
                _ = "Error: \(error.localizedDescription)"
            }
        }
        
        locationViewModel.authorizationStatus = { [weak self] status in
            DispatchQueue.global().async {
                switch status {
                case .notDetermined:
                    break
                case .restricted, .denied:
                    _ = "Location services are restricted or denied, go to Settings -> Location Services to enable  them"
                case .authorizedWhenInUse, .authorizedAlways:
                    self?.checkLocationStatus()
                    break
                @unknown default:
                    break
                }
            }
        }
        
        checkLocationStatus()
    }
    
    func checkLocationStatus() {
        DispatchQueue.global().async {
            let status = CLLocationManager().authorizationStatus.rawValue
            if status == 2 || status == 0 {
                DispatchQueue.main.async {
                    self.locationStatus.text = "Location Service Unavailable"
                    self.btnSearch.isEnabled = false
                }
            } else {
                DispatchQueue.main.async {
                    self.locationStatus.isHidden = true
                }
                self.weatherViewModel.fetchCurrentWeather()
            }
        }
    }
    
    //MARK: - ----- LifeCycle -----
    override func viewWillAppear(_ animated: Bool) {
        self.weatherViewModel.fetchCurrentWeather()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
}


//MARK: - ----- CurrentWeather VIEW MODEL DELEGATE -----
extension MainVC: CurrentWeatherViewModelDelegate {
    func weatherFetched(data: ParseCurrentWeather) {
        ///Update on main queue
        DispatchQueue.main.async {
            self.location.text = data.name
            self.temperature.text = data.temp.stringValueWholeNumber + "°"
            self.weatherCondition.text = (data.description.capitalized)
            self.highestTemperature.text = data.tempMax.stringValueWholeNumber + "°"
            self.lowestTemperature.text = data.tempMin.stringValueWholeNumber + "°"
            self.humidity.text = data.humidity.stringValue
            self.rain.text = data.rain?.stringValueWholeNumber
            self.snow.text = data.snow?.stringValueWholeNumber
            self.wind.text = data.wind.stringValueWholeNumber
        }
    }
    
    func weatherFetchFailure(err: any Error) {
        print("Got Error trying to fetch weather")
    }
}

