//
//  SearchViewModelImpl.swift
//  weather-app
//
//  Created by Miran Hrupački on 01/06/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation
import RxSwift

class SearchViewModelImpl: SearchViewModel {
    var dataSource: CityByNameView?
    var screenData: WeatherResponse?
    var networkManager: NetworkManager
    var weatherResponse: WeatherResponse
    var city = "London"

    let loaderSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    let alertObservable = ReplaySubject<()>.create(bufferSize: 1)
    var searchDataStatusObservable = ReplaySubject<(Bool)>.create(bufferSize: 1)
    var searchReplaySubject = ReplaySubject<()>.create(bufferSize: 1)
    var citySearchButtonReplaySubject = ReplaySubject<()>.create(bufferSize: 1)
    var searchCityObservable = ReplaySubject<(String)>.create(bufferSize: 1)
    
    init(networkManager: NetworkManager, weatherResponse: WeatherResponse) {
        self.networkManager = networkManager
        self.weatherResponse = weatherResponse
    }
    
    func loadData() {
        loaderSubject.onNext(true)
        searchReplaySubject.onNext(())
        citySearchButtonReplaySubject.onNext(())
    }
    
    func initializeLoadDataSubject() -> Disposable {
        return searchCityObservable
            .flatMap { [unowned self] (name) -> Observable<WeatherResponse> in
                return self.networkManager.getCityByName(url: "https://api.openweathermap.org/data/2.5/weather?q=\(name)")
        }
        .map{ (data) in
            return self.createScreenData(data: data)
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
        .subscribe(
            onNext: { [unowned self](weatherList) in
                self.dataSource = weatherList
    self.searchDataStatusObservable.onNext(true)
            }, onError: { [unowned self]error in
                self.loaderSubject.onNext(false)
                
        })
    }
    
    private func createScreenData(data: WeatherResponse) -> (CityByNameView){
           if !DatabaseManager.isCitySearched(with: self.city) {
               DatabaseManager.searchedCity(with: data)
           }
           screenData = data
           let searched = DatabaseManager.isCitySearched(with: data.name!)
           return CityByNameView(id: data.id, name: data.name ?? "abc", temperature: data.main.temp , image: data.weather[0].icon, searched: searched )
       }
}
