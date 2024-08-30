//
//  Networking.swift
//  WeatherAppProject
//
//  Created by Fahad Saleem on 8/29/24.
//

import Foundation

final class Networking {
    private let session = URLSession.shared
    
    func fetchData<T: Decodable>(from url: URLRequest, model: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        ///Create a data task to fetch the data
        let task = session.dataTask(with: url) { (data, response, error) in
            // Check for errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            ///Check if a response was received
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkingError.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
                ///For Valid Response
            case 200...299:
                guard let data = data else {
                    completion(.failure(NetworkingError.noDataReceived))
                    return
                }
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(NetworkingError.unknownError))
                }
                ///For Invalid Responses with error
            case 400:
                completion(.failure(NetworkingError.badRequest))
            case 401:
                completion(.failure(NetworkingError.unauthorized))
            case 404:
                completion(.failure(NetworkingError.notFound))
            case 500...599:
                completion(.failure(NetworkingError.serverError))
            default:
                completion(.failure(NetworkingError.unknownError))
            }
        }
        
        // Start the data task
        task.resume()
    }
}
