//
//  SearchCityViewController.swift
//  weather-app
//
//  Created by Miran Hrupački on 26/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class SearchCityViewController: UIViewController, UISearchBarDelegate {
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .init(red: 0.36, green: 0.64, blue: 0.77, alpha: 1.00)
        return tableView
    }()
    
    var searchBar: UISearchBar = {
        let search = UISearchBar()
        return search
    }()
    
    var dataSource: CityByNameView?
    var screenData: WeatherResponse?
    let disposeBag = DisposeBag()
    let loaderIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    let networkManager = NetworkManager()
    let data = CurrentCityViewModelImpl(networkManager: NetworkManager(), weatherResponse: WeatherResponse(coord: Coordinates(lon: 45.5550, lat: 18.6955), main: CurrentWeather(temp: 0, humidity: 0), weather: [Weather](), id: 0, name: "Osijek"))
    let citySearchReplaySubject = ReplaySubject<()>.create(bufferSize: 1)
    var city = "London"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchBar)

        setupUI()
        setSearchBarDelegate()
        citySearchReplaySubject.onNext(())
    }
    
    func setSearchBarDelegate() {
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        city = (self.searchBar.text! as NSString).replacingOccurrences(of: " ", with: "+")
        showData(for: citySearchReplaySubject).disposed(by: disposeBag)
    }
    
    func showData(for subject: ReplaySubject<()>) -> Disposable {
        return subject
            .flatMap { [unowned self] (_) -> Observable<WeatherResponse> in
                DispatchQueue.main.async {
                    self.loaderIndicator.startAnimating()
                }
                return self.networkManager.getCityByName(url: "https://api.openweathermap.org/data/2.5/weather?q=\(self.city)")
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
                self.showAlertWith(title: "Search city weather network error", message: "City weather couldn't load")
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
    
    func setupUI() {
        configureTableView()
        setupConstraints()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(SearchCityTableViewCell.self, forCellReuseIdentifier: Cells.cityCell)
    }
    
    func setupConstraints(){
        tableView.snp.makeConstraints { (maker) in
            maker.bottom.trailing.leading.equalToSuperview()
            maker.top.equalTo(searchBar.snp.bottom)
        }
        
        searchBar.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SearchCityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource == nil {
            return 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.cityCell) as! SearchCityTableViewCell
        
        let cityWeather = dataSource ?? nil
        cell.configure(cityWeather: cityWeather!)
        
        return cell
    }
}
