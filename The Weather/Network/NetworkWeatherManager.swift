//
//  NetworkWeatherManager.swift
//  The Weather
//
//  Created by Дмитрий Скок on 14.04.2023.
//

import Foundation
import CoreLocation

enum NetworkError: Error {
    case parseError
    case requestError(Error)
}

enum RequestType {
    case cityName(city: String)
    case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
}

final class NetworkWeatherManager {
    private let session = URLSession.shared
    typealias onCompletion = (Result<CurrentWeatherData, NetworkError>) -> Void

    func fetchCurrentWeather(
        forRequestType requestType: RequestType,
        url: URL,
        completion: @escaping onCompletion
    ) {
        var url: URL

        switch requestType {
        case .cityName(let city):
            let params = ["q": city]
            url = configureUrl(params: params)
        case .coordinate(let latitude, let longitude):
            let params = [
                "lat": String(latitude),
                "lon": String(longitude)
            ]
            url = configureUrl(params: params)
        }

        let task = session.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(.requestError(error)))
            }

            guard let data else {
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let result = try decoder.decode(CurrentWeatherData.self, from: data)
                return completion(.success(result))
            } catch {
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
}

private extension NetworkWeatherManager {
    func configureUrl(params: [String: String]) -> URL {
        var queryItems = [URLQueryItem]()
        params.forEach { (name, value) in
            queryItems.append(URLQueryItem(name: name, value: value))
        }
        queryItems.append(URLQueryItem(name: "appid", value: Constants.apiKey))
        queryItems.append(URLQueryItem(name: "units", value: "metric"))

        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.path
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            fatalError("URL invalid")
        }
        return url
    }
}

