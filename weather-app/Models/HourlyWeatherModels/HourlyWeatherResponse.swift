//
//  HourlyWeatherResponse.swift
//  weather-app
//
//  Created by Miran Hrupački on 21/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation

public struct HourlyWeatherResponse: Codable {
    let hourly: [Hourly]
}

public struct Hourly: Codable {
    let dt: Int?
    let temp: Double?
    let description: String?
    let icon: String?
    let weather: [WeatherInfo]
}

public struct WeatherInfo: Codable {
    let description: String
    let icon: String
}
