//
//  MainViewControllerViewModelImpl.swift
//  weather-app
//
//  Created by Miran Hrupački on 01/06/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation
import RxSwift

class MainViewControllerViewModelImpl: MainViewControllerViewModel {
    let searchBarSubject = PublishSubject<()>()
    var dataSource = [WeatherResponse]()
    var databaseManager: DatabaseManager
    var networkManager: NetworkManager
    var cityDataStatusObservable = ReplaySubject<(Bool)>.create(bufferSize: 1)
    
    init(databaseManager: DatabaseManager, networkManager: NetworkManager){
        self.databaseManager = databaseManager
        self.networkManager = networkManager
    }
    
    func updateData() {
        dataSource = DatabaseManager.getSearchedCities()
        cityDataStatusObservable.onNext(true)
      }
}
