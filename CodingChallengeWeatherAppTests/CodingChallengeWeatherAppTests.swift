//
//  CodingChallengeWeatherAppTests.swift
//  CodingChallengeWeatherAppTests
//
//  Created by Fahad Saleem on 8/29/24.
//

import XCTest
@testable import CodingChallengeWeatherApp

final class CodingChallengeWeatherAppTests: XCTestCase {
    
    func testCurrentWeatherViewModelForFailure() {
        let modelSpy = CurrentWeatherViewModelSpy()
        let mockModel = NetworkingMock()
        let sut = CurrentWeatherViewModel(networking: mockModel)
        sut.delegate = modelSpy
        sut.fetchCurrentWeather()
        XCTAssertTrue(modelSpy.hasWeatherFetchFailureCalled)
    }
    
    func testCurrentWeatherViewModelForSuccess() {
        let modelSpy = CurrentWeatherViewModelSpy()
        let mockModel = NetworkingMock()
        mockModel.isData = true
        let sut = CurrentWeatherViewModel(networking: mockModel)
        sut.delegate = modelSpy
        sut.fetchCurrentWeather()
        XCTAssertTrue(modelSpy.hasSuccessFetchedCalled)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class NetworkingMock: CurrentWeatherNetworkingProtocol {
    let mockData = ParseCurrentWeather(name: "mockCity", main: "main", description: "desc", icon: "icon", humidity: 1, temp: 2.0, tempMin: 3.0, tempMax: 4.0, wind: 5.0, rain: 6.0, snow: 7.0)
    var isData = false
    func fetchCurrentWeather(lat: String, lon: String, completion: @escaping (Result<ParseCurrentWeather, any Error>) -> Void) {
        if !isData {
            completion(.failure(NetworkingError.badRequest))
        } else {
            completion(.success(mockData))
        }
    }
}

class CurrentWeatherViewModelSpy: CurrentWeatherViewModelDelegate {
    var hasSuccessFetchedCalled = false
    var hasWeatherFetchFailureCalled = false
    
    func weatherFetchFailure(err: any Error) {
         hasWeatherFetchFailureCalled = true
    }
    
    func weatherFetched(data: CodingChallengeWeatherApp.ParseCurrentWeather) {
        hasSuccessFetchedCalled = true
    }
}
