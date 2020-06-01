//
//  UserInteraction.swift
//  weather-app
//
//  Created by Miran Hrupački on 28/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation

protocol UserInteraction: class {
    func searchCityPressed(with name: String)
}
