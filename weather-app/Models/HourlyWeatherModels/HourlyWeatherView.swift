//
//  HourlyWeatherView.swift
//  weather-app
//
//  Created by Miran Hrupački on 21/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation

struct HourlyWeatherView {
    let id: Int
    var name: String
    let temperature: Double
    let image: String
    let date: Int

    init(id: Int, name:String, temperature: Double, image: String, date: Int){
        self.id = id
        self.name = name
        self.temperature = temperature
        self.image = image
        self.date = date
    }
}
