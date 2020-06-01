//
//  DatabaseManager.swift
//  weather-app
//
//  Created by Miran Hrupački on 28/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation

struct DatabaseKeys{
    static let searched = "searched"
}

class DatabaseManager {
    static let defaults = UserDefaults.standard

    static func isCitySearched(with name: String) -> Bool{
        guard let searchedNames = defaults.array(forKey: DatabaseKeys.searched) as? [WeatherResponse] else {return false}
        for response in searchedNames {
            if response.name == name {
                return true
            }
        }
        return false
    }
    
    static func searchedCity(with weatherResponse: WeatherResponse){
        guard var searchedNames = defaults.object([WeatherResponse].self, with: DatabaseKeys.searched) else {
            defaults.set(object: [weatherResponse], forKey: DatabaseKeys.searched)
            return
        }
        searchedNames.append(weatherResponse)
        defaults.set(object: searchedNames, forKey: DatabaseKeys.searched)
        defaults.synchronize()
    }
    
    static func getSearchedCities() -> [WeatherResponse]{
        guard let searchedNames = defaults.object([WeatherResponse].self, with: DatabaseKeys.searched) else {
            return [WeatherResponse]()
        }
        return searchedNames
    }
}

extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }
    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}
