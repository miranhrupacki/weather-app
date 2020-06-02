//
//  MainViewControllerViewModel.swift
//  weather-app
//
//  Created by Miran Hrupački on 01/06/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation
import RxSwift

protocol MainViewControllerViewModel {
    var searchBarSubject: PublishSubject<()> {get}
    var dataSource: [WeatherResponse] {get}
    var cityDataStatusObservable: ReplaySubject<(Bool)> {get}
    func updateData()
}
