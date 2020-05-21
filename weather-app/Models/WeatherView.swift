//
//  Weather.swift
//  weather-app
//
//  Created by Miran Hrupački on 19/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation

struct WeatherView {
    let id: Int
    var name: String
    let temperature: Double
    let image: String
    let description: String
    let humidity: Int

    init(id: Int, name:String, temperature: Double, image: String, description: String, humidity: Int){
        self.id = id
        self.name = name
        self.temperature = temperature
        self.image = image
        self.description = description
        self.humidity = humidity
    }
}
