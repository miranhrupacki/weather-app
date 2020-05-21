//
//  Response.swift
//  weather-app
//
//  Created by Miran Hrupački on 19/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation

public struct Response<T: Codable>: Codable {
    let results: T?
}
