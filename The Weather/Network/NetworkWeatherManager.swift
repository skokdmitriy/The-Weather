//
//  NetworkWeatherManager.swift
//  The Weather
//
//  Created by Дмитрий Скок on 14.04.2023.
//

import Foundation

let apiKey = "de876f95487677a4c16171d8abf780c4"

struct NetworkWeatherManager {
    func fetchCurrentWeather(forCity city: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        let session: URLSession = {
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            return session
        }()
        let task = session.dataTask(with: url) { data, response, Error in
            if let data = data {
                let dataString = String(data: data, encoding: .utf8)
                print(dataString!)
            }
        }
        task.resume()
    }
}
