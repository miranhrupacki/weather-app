//
//  SearchViewModel.swift
//  weather-app
//
//  Created by Miran Hrupački on 01/06/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchViewModel {
    var dataSource: CityByNameView? {get}
    var screenData: WeatherResponse? {get}
    var searchDataStatusObservable: ReplaySubject<(Bool)> {get}
    var citySearchButtonReplaySubject: ReplaySubject<()> {get}
    var searchReplaySubject: ReplaySubject<()> {get}
    var loaderSubject: ReplaySubject<Bool> {get}
    var alertObservable: ReplaySubject<()> {get}
    var searchCityObservable: ReplaySubject<(String)> {get}
    func loadData()
    func initializeLoadDataSubject() -> Disposable
    
}
