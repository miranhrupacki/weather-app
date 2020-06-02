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
    
    let viewModel: SearchViewModel
    let disposeBag = DisposeBag()
    let loaderIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    let data = CurrentCityViewModelImpl(networkManager: NetworkManager(), weatherResponse: WeatherResponse(coord: Coordinates(lon: 45.5550, lat: 18.6955), main: CurrentWeather(temp: 0, humidity: 0), weather: [Weather](), id: 0, name: "Osijek"))
    var city = "London"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchBar)
        setupUI()
        setSearchBarDelegate()
        viewModel.loadData()
        viewModel.initializeLoadDataSubject().disposed(by: disposeBag)
        initializeLoaderObservable().disposed(by: disposeBag)
        initializeAlertObservable().disposed(by: disposeBag)
        initializeDataStatusObservable().disposed(by: disposeBag)
        viewModel.citySearchButtonReplaySubject.disposed(by: disposeBag)
    }
    
    init(weatherResponse: WeatherResponse) {
        viewModel = SearchViewModelImpl(networkManager: NetworkManager(), weatherResponse: weatherResponse)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSearchBarDelegate() {
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        city = (self.searchBar.text! as NSString).replacingOccurrences(of: " ", with: "+")
        viewModel.searchCityObservable.onNext((city))
    }

    private func initializeAlertObservable() -> Disposable{
        viewModel.alertObservable
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [unowned self] type in
                self.showAlertWith(title: "Weather network error", message: "Weather couldn't load")
                }
        )
    }
    
    private func initializeLoaderObservable() -> Disposable{
        viewModel.loaderSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext:{ [unowned self] status in
                self.checkLoaderStatus(status: status)
            })
    }
    
    private func checkLoaderStatus(status: Bool){
        if status{
            self.loaderIndicator.startAnimating()
        }
        else{
            self.loaderIndicator.stopAnimating()
        }
    }
    
    func initializeDataStatusObservable() -> Disposable {
        viewModel.searchDataStatusObservable
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (status) in
                if status {
                    self.tableView.reloadData()
                }
            })
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
        if viewModel.dataSource == nil {
            return 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.cityCell) as! SearchCityTableViewCell
        
        let cityWeather = viewModel.dataSource ?? nil
        cell.configure(cityWeather: cityWeather!)
        
        return cell
    }
}
