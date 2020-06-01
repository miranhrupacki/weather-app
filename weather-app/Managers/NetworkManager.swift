//
//  NetworkManager.swift
//  weather-app
//
//  Created by Miran Hrupački on 19/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa
import CoreLocation

class NetworkManager{
    
    enum NetworkError: Error {
        case error
    }
    
    let parameters: Parameters = {
        var parameters = Parameters()
        parameters["appid"] = "89e1155c439168e3cf9ffa285d4a03c4"
        return parameters
    }()
    
    func getData(url: String) -> Observable<WeatherResponse> {
        return Observable.create { observer in
            
            let endpoint = "\(url)&appid=89e1155c439168e3cf9ffa285d4a03c4"
            AF.request(endpoint, parameters: nil).validate().responseDecodable(of: WeatherResponse.self, decoder: SerializationManager.jsonDecoder) { (weatherResponse) in
                switch weatherResponse.result {
                case .success:
                    do {
                        let response = try weatherResponse.result.get()
                        observer.onNext(response)
                        observer.onCompleted()
                    }
                    catch let error{
                        debugPrint("Error happed: ", error.localizedDescription)
                    }
                case.failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create{
                AF.request(endpoint).cancel()
            }
        }
    }
    
    func getHourlyData(url: String) -> Observable<HourlyWeatherResponse> {
        return Observable.create { observer in
            let endpoint = "\(url)&appid=89e1155c439168e3cf9ffa285d4a03c4"
            AF.request(endpoint, parameters: nil).validate().responseDecodable(of: HourlyWeatherResponse.self, decoder: SerializationManager.jsonDecoder) { (hourlyWeatherResponse) in
                switch hourlyWeatherResponse.result {
                case .success:
                    do {
                        let response = try hourlyWeatherResponse.result.get()
                        observer.onNext(response)
                        observer.onCompleted()
                    }
                    catch let error{
                        debugPrint("Error happed: ", error.localizedDescription)
                    }
                case.failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create{
                AF.request(endpoint).cancel()
            }
        }
    }
    
    func getCityByName(url: String) -> Observable<WeatherResponse> {
        return Observable.create { observer in
            let endpoint = "\(url)&appid=89e1155c439168e3cf9ffa285d4a03c4"
            AF.request(endpoint, parameters: nil).validate().responseDecodable(of: WeatherResponse.self, decoder: SerializationManager.jsonDecoder) { (weatherResponse) in
                switch weatherResponse.result {
                case .success:
                    do {
                        let response = try weatherResponse.result.get()
                        observer.onNext(response)
                        observer.onCompleted()
                    }
                    catch let error{
                        debugPrint("Error happed: ", error.localizedDescription)
                    }
                case.failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create{
                AF.request(endpoint).cancel()
            }
        }
    }
}
