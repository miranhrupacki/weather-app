//
//  CityByNameResponse.swift
//  weather-app
//
//  Created by Miran Hrupački on 27/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation

public struct CityByNameResponse: Codable {
    let weather: [CityWeather]
    let main: CityCurrentWeather
    let name: String?
    let id: Int
}

public struct CityWeather: Codable {
    let main: String
    let description: String
    let icon: String
}

public struct CityCurrentWeather: Codable {
    let temp: Double
}
