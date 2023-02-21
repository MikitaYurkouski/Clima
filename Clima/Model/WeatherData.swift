//
//  WeatherData.swift
//  Clima
//
//  Created by Никита Юрковский on 20.02.23.
//

import Foundation
import CoreLocation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let description: String
    let id: Int
}
