//
//  HourlyViewController.swift
//  weather-app
//
//  Created by Miran Hrupački on 21/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HourlyViewController: UIViewController {
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .init(red: 0.36, green: 0.64, blue: 0.77, alpha: 1.00)
        return tableView
    }()
    
    let loaderIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    var dataSource = [HourlyWeatherView]()
    var screenData: HourlyWeatherResponse?
    let disposeBag = DisposeBag()
    let hourlyWeatherReplaySubject = ReplaySubject<()>.create(bufferSize: 1)
    var lat = 51.5074
    var lon = 0.1278
    

        
    private let networkManager: NetworkManager
    
    struct Cells{
        static let hourlyCell = "HourlyTableViewCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        hourlyWeatherReplaySubject.onNext(())
    }
    
    init(networkManager: NetworkManager){
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        configureTableView()
        
        setupConstraints()
            setupSubscriptions()
    }
    
    func setupSubscriptions() {
        showData(for: hourlyWeatherReplaySubject).disposed(by: disposeBag)
    }
    
    func showData(for subject: ReplaySubject<()>) -> Disposable {
        return subject
            .flatMap { [unowned self] (_) -> Observable<HourlyWeatherResponse> in
                DispatchQueue.main.async {
                    self.loaderIndicator.startAnimating()
                }
                return self.networkManager.getHourlyData(url:                       "https://api.openweathermap.org/data/2.5/onecall?lat=\(self.lat)&lon=\(self.lon)&exclude=minutely,daily")
        }

        .map{ (data) in
            return self.createScreenData(data: data)
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
        .subscribe(
            onNext: { [unowned self](weatherList) in
                self.dataSource = weatherList
                DispatchQueue.main.async {
                    self.loaderIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }, onError: { [unowned self]error in
                self.showAlertWith(title: "Hourly weather network error", message: "Hourly weather couldn't load")
        })
    }

    private func createScreenData(data: HourlyWeatherResponse) -> ([HourlyWeatherView]){
        screenData = data
        return data.hourly.map { (data) -> HourlyWeatherView in
            
            return HourlyWeatherView(id:  1, name: "", temperature: data.temp ?? 1, image: data.weather[0].icon, date: data.dt ?? 1)
        }
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        setTableViewDelegates()
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(HourlyTableViewCell.self, forCellReuseIdentifier: Cells.hourlyCell)
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

extension HourlyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource == nil {
            return 0
        } else {
            return screenData?.hourly.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.hourlyCell) as! HourlyTableViewCell
        
        let hourlyWeather = dataSource[indexPath.row]
        cell.configure(hourlyWeather: hourlyWeather)
        
        return cell
    }
}
