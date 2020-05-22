//
//  MainViewController.swift
//  weather-app
//
//  Created by Miran Hrupački on 19/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    let searchButton: UIButton = {
        let search = UIButton()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.backgroundColor = .init(red: 0.45, green: 0.63, blue: 0.95, alpha: 1.00)
        search.setTitle("Click for hourly weather", for: .normal)
        search.layer.cornerRadius = 23
        search.titleLabel?.numberOfLines = 0
        search.titleLabel?.adjustsFontSizeToFitWidth = true
        search.titleLabel?.textAlignment = .center
        search.titleLabel?.font = UIFont.init(name: "Quicksand-Regular", size: 20)
        return search
    }()
    
    let currentWeatherButton: UIButton = {
        let weather = UIButton()
        weather.translatesAutoresizingMaskIntoConstraints = false
        weather.backgroundColor = .init(red: 0.45, green: 0.63, blue: 0.95, alpha: 1.00)
        weather.layer.cornerRadius = 23
        weather.titleLabel?.numberOfLines = 0
        weather.titleLabel?.adjustsFontSizeToFitWidth = true
        weather.titleLabel?.textAlignment = .center
        weather.setTitle("Click here for your current city temperature", for: .normal)
        weather.titleLabel?.font = UIFont.init(name: "Quicksand-Regular", size: 20)
        return weather
    }()
    
    let mapButton: UIButton = {
        let map = UIButton()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.backgroundColor = .init(red: 0.45, green: 0.63, blue: 0.95, alpha: 1.00)
        map.layer.cornerRadius = 23
        map.titleLabel?.numberOfLines = 0
        map.titleLabel?.adjustsFontSizeToFitWidth = true
        map.titleLabel?.textAlignment = .center
        map.setTitle("Click for map screen", for: .normal)
        map.titleLabel?.font = UIFont.init(name: "Quicksand-Regular", size: 20)
        return map
    }()
    
    let currentCityButtonSubject = PublishSubject<()>()
    let hourlyWeatherButtonnSubject = PublishSubject<()>()
    let mapButtonnSubject = PublishSubject<()>()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchButton)
        view.addSubview(currentWeatherButton)
        view.addSubview(mapButton)
        view.backgroundColor = .init(red: 0.43, green: 0.45, blue: 0.47, alpha: 1.00)
        
        currentWeatherButton.addTarget(self, action: #selector(pushToDefaultCityView), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(pushToHourlyWeatherView), for: .touchUpInside)
        mapButton.addTarget(self, action: #selector(pushToMapView), for: .touchUpInside)

        // Do any additional setup after loading the view.
        setupUI()
        setupSubscriptions()
    }
    
    func setupUI(){
        setupConstraints()
    }
    
    @objc func pushToHourlyWeatherView() {
         let vc = HourlyViewController()
         self.navigationController?.pushViewController(vc, animated: true)
     }
    
    @objc func pushToDefaultCityView() {
        let vc = CurrentCityViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pushToMapView() {
        let vc = MapViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func initializeCurrentCitySubject(for subject: PublishSubject<()>) -> Disposable{
        return subject
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [unowned self] in
            self.pushToDefaultCityView()
        })
    }
    
    func initializeHourlyWeatherSubject(for subject: PublishSubject<()>) -> Disposable{
        return subject
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [unowned self] in
            self.pushToHourlyWeatherView()
        })
    }
    
    func initializeMapSubject(for subject: PublishSubject<()>) -> Disposable{
        return subject
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [unowned self] in
            self.pushToMapView()
        })
    }
    
    func setupSubscriptions() {
        initializeCurrentCitySubject(for: currentCityButtonSubject).disposed(by: disposeBag)
        initializeHourlyWeatherSubject(for: hourlyWeatherButtonnSubject).disposed(by: disposeBag)
        initializeMapSubject(for: mapButtonnSubject).disposed(by: disposeBag)
    }
    
    func setupConstraints(){
        
        searchButton.snp.makeConstraints{(maker) in
            maker.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            maker.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(50)
            maker.height.equalTo(150)
        }
        
        currentWeatherButton.snp.makeConstraints{(maker) in
            maker.top.equalTo(searchButton.snp.bottom).inset(-50)
            maker.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(50)
            maker.height.equalTo(150)
        }
        
        mapButton.snp.makeConstraints{(maker) in
            maker.top.equalTo(currentWeatherButton.snp.bottom).inset(-50)
            maker.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(50)
            maker.height.equalTo(150)
        }
    }
}
