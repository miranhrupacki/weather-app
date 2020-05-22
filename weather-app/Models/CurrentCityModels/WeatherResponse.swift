//
//  WeatherResponse.swift
//  weather-app
//
//  Created by Miran Hrupački on 19/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation

public struct WeatherResponse: Codable {
    let coord: Coordinates
    let main: CurrentWeather
    let weather: [Weather]
    let wind: Wind
    let sys: Sun
    let id: Int
    let name: String?
}

public struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

public struct Weather: Codable {
    let id: Int
    let description: String
    let icon: String
}

public struct CurrentWeather: Codable {
    let temp: Double
    let humidity: Int
    let tempMin: Double
    let tempMax: Double
}

public struct Wind: Codable {
    let speed: Double
    let deg: Int?
}

public struct Sun: Codable {
    let country: String
    let sunrise: Int
    let sunset: Int
}
