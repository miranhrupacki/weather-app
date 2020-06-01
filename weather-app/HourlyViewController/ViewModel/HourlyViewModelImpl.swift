//
//  HourlyViewModelImpl.swift
//  weather-app
//
//  Created by Miran Hrupački on 22/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation
import RxSwift

class HourlyViewModelImpl: HourlyViewModel {
    
    var dataSource = [HourlyWeatherView]()
    var screenData: HourlyWeatherResponse?
    private var networkManager: NetworkManager
    var weatherResponse: WeatherResponse
    var hourlyWeatherDataStatusObservable = ReplaySubject<(Bool)>.create(bufferSize: 1)
    var hourlyWeatherReplaySubject = ReplaySubject<()>.create(bufferSize: 1)
    var loaderSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    var alertObservable = ReplaySubject<()>.create(bufferSize: 1)
    
    init(networkManager: NetworkManager, weatherResponse: WeatherResponse) {
        self.networkManager = networkManager
        self.weatherResponse = weatherResponse
    }
    
    func loadData() {
        loaderSubject.onNext(true)
        hourlyWeatherReplaySubject.onNext(())
    }
    
    func initializeLoadDataSubject() -> Disposable {
        return hourlyWeatherReplaySubject
            .flatMap { [unowned self] (_) -> Observable<HourlyWeatherResponse> in
                return self.networkManager.getHourlyData(url:"https://api.openweathermap.org/data/2.5/onecall?lat=\(self.weatherResponse.coord.lat)&lon=\(self.weatherResponse.coord.lon)&exclude=minutely,daily")
        }
        .map{ (data) in
            return self.createScreenData(data: data)
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
        .subscribe(
            onNext: { [unowned self](weatherList) in
                self.dataSource = weatherList
                self.hourlyWeatherDataStatusObservable.onNext(true)
            }, onError: { [unowned self]error in
                self.loaderSubject.onNext(false)
        })
    }
    
    private func createScreenData(data: HourlyWeatherResponse) -> ([HourlyWeatherView]){
        screenData = data
        return data.hourly.map { (data) -> HourlyWeatherView in
            return HourlyWeatherView(id:  1, name: "", temperature: data.temp ?? 1, image: data.weather[0].icon, date: data.dt ?? 1)
        }
    }
}
