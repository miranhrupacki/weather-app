//
//  CityByNameView.swift
//  weather-app
//
//  Created by Miran Hrupački on 27/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation

struct CityByNameView {
    let id: Int
    var name: String
    let temperature: Double
    let image: String
    var searched: Bool

    init(id: Int, name:String, temperature: Double, image: String, searched: Bool){
        self.id = id
        self.name = name
        self.temperature = temperature
        self.image = image
        self.searched = searched
    }
}
