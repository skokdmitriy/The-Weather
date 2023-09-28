//
//  CurrentWeatherData.swift
//  The Weather
//
//  Created by Дмитрий Скок on 25.04.2023.
//

import Foundation

struct CurrentWeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    let feelsLike: Double
}

struct Weather: Decodable {
    let id: Int
}
