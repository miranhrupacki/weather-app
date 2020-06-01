//
//  CurrentCityViewModelImpl.swift
//  weather-app
//
//  Created by Miran Hrupački on 22/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation
import RxSwift

class CurrentCityViewModelImpl: CurrentCityViewModel {
    
    private var networkManager: NetworkManager
    var screenData: CityByNameView?
    var weatherResponse: WeatherResponse
    var weatherDataStatusObservable = ReplaySubject<(Bool)>.create(bufferSize: 1)
    var weatherReplaySubject = ReplaySubject<()>.create(bufferSize: 1)
    let loaderSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    let alertObservable = ReplaySubject<()>.create(bufferSize: 1)
    
    init(networkManager: NetworkManager, weatherResponse: WeatherResponse) {
        self.networkManager = networkManager
        self.weatherResponse = weatherResponse
    }
    
    func loadData() {
        loaderSubject.onNext(true)
        weatherReplaySubject.onNext(())
    }
    
    func initializeLoadDataSubject() -> Disposable{
        return weatherReplaySubject
            .flatMap { [unowned self] (_) -> Observable<WeatherResponse> in
                return self.networkManager.getCityByName(url: "https://api.openweathermap.org/data/2.5/weather?q=\(self.weatherResponse.name)")
        }
        .map{ [unowned self] in
            return self.createScreenData(data: $0)
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
        .subscribe(
            onNext: { [unowned self] (city) in
                self.screenData = city
                self.weatherDataStatusObservable.onNext(true)
            }, onError: { [unowned self] error in
                self.loaderSubject.onNext(false)
        })
    }
    
    private func createScreenData(data: WeatherResponse) -> (CityByNameView){
        let searched = DatabaseManager.isCitySearched(with: data.name!)
        return CityByNameView(id: data.id, name: data.name ?? "abc", temperature: data.main.temp , image: data.weather[0].icon, searched: searched )
    }
    
//    func createScreenData(weather: WeatherResponse)  -> [WeatherCellItem] {
//        var screenData: [WeatherCellItem] = []
//        screenData.append(WeatherCellItem(type: .image, data: weather.weather[0].icon))
//        screenData.append(WeatherCellItem(type: .temperature, data: weather.main.temp))
//        screenData.append(WeatherCellItem(type: .humidity, data: weather.main.humidity))
//        screenData.append(WeatherCellItem(type: .description, data: weather.weather[0].description))
//        screenData.append(WeatherCellItem(type: .name, data: weather.name ?? ""))
//
//        return screenData
//    }
}
