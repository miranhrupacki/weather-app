//
//  CurrentCityViewModel.swift
//  weather-app
//
//  Created by Miran Hrupački on 22/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation
import RxSwift

protocol CurrentCityViewModel {
    var screenData: CityByNameView? {get}
    var weatherDataStatusObservable: ReplaySubject<(Bool)> {get}
    var loaderSubject: ReplaySubject<Bool> {get}
    var alertObservable: ReplaySubject<()> {get}
    func loadData()
    func initializeLoadDataSubject() -> Disposable
}
