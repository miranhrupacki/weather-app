//
//  ViewController.swift
//  weather-app
//
//  Created by Miran Hrupački on 19/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController{
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .init(red: 0.36, green: 0.64, blue: 0.77, alpha: 1.00)
        return tableView
    }()
    
    let disposeBag = DisposeBag()
    let loaderIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var dataSource = [WeatherView]()
    var screenData = [WeatherCellItem]()
    private let networkManager: NetworkManager
    let weatherReplaySubject = ReplaySubject<()>.create(bufferSize: 1)
    var lat = 45.7621
    var lon = 18.1651
                
    struct Cells{
        static let weatherCell = "WeatherTableViewCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupSubscriptions()
        weatherReplaySubject.onNext(())
    }

    func setupUI(){
        configureTableView()
        setupConstraints()
    }
    
    init(networkManager: NetworkManager){
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubscriptions() {
        showData(for: weatherReplaySubject).disposed(by: disposeBag)
    }
    
    func showData(for subject: ReplaySubject<()>) -> Disposable {
        return subject
            .flatMap { [unowned self] (_) -> Observable<WeatherResponse> in
                DispatchQueue.main.async {
                    self.loaderIndicator.startAnimating()
                }
                return self.networkManager.getData(url: "https://api.openweathermap.org/data/2.5/weather?lat=\(self.lat)&lon=\(self.lon)")
        }
        .map{ [unowned self] in
            return self.createScreenData(weather: $0)
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
        .subscribe(
            onNext: { [unowned self](weatherList) in
                self.screenData = weatherList
                DispatchQueue.main.async {
                    self.loaderIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }, onError: { [unowned self]error in
                self.showAlertWith(title: "Weather network error", message: "Weather couldn't load")
        })
    }
    
    func createScreenData(weather: WeatherResponse)  -> [WeatherCellItem] {
        var screenData: [WeatherCellItem] = []
        screenData.append(WeatherCellItem(type: .image, data: weather.weather[0].icon))
        screenData.append(WeatherCellItem(type: .temperature, data: weather.main.temp))
        screenData.append(WeatherCellItem(type: .humidity, data: weather.main.humidity))
        screenData.append(WeatherCellItem(type: .description, data: weather.weather[0].description))
        screenData.append(WeatherCellItem(type: .name, data: weather.name ?? ""))

        return screenData
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        tableView.register(CurrentTemperatureTableViewCell.self, forCellReuseIdentifier: "CurrentTemperatureCell")
        tableView.register(CityNameTableViewCell.self, forCellReuseIdentifier: "CityNameCell")
        tableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: "DescriptionCell")
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageCell")
        tableView.register(HumidityTableViewCell.self, forCellReuseIdentifier: "HumidityCell")
    }
    
    func setupConstraints(){
        
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = screenData[indexPath.row]
        
        switch item.type {
            
        case .temperature:
            guard let safeData = item.data as? Double else {return UITableViewCell()}
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentTemperatureCell", for: indexPath) as?
                CurrentTemperatureTableViewCell else {
                    fatalError("The dequeued cell is not an instance of CurrentTemperatureCell.")}
            cell.configure(temperature: safeData)
            
            return cell
            
        case .description:
            guard let safeData = item.data as? String else {return UITableViewCell()}
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as?
                DescriptionTableViewCell else {
                    fatalError("The dequeued cell is not an instance of DescriptionCell.")}
            cell.configure(description: safeData)
            
            return cell
            
        case .image:
            guard let safeData = item.data as? String else {return UITableViewCell()}
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as?
                ImageTableViewCell else {
                    fatalError("The dequeued cell is not an instance of ImageCell.")}
            cell.configure(image: safeData, weather: item)
            
            return cell
            
        case .name:
            guard let safeData = item.data as? String else {return UITableViewCell()}
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityNameCell", for: indexPath) as?
                CityNameTableViewCell else {
                    fatalError("The dequeued cell is not an instance of CityNameCell.")}
            cell.configure(name: safeData)
            
            return cell
            
            case .humidity:
            guard let safeData = item.data as? Int else {return UITableViewCell()}
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HumidityCell", for: indexPath) as?
                HumidityTableViewCell else {
                    fatalError("The dequeued cell is not an instance of HumidityCell.")}
            cell.configure(humidity: safeData)
            
            return cell
        }
    }
}
