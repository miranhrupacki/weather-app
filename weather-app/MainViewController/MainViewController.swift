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
    
    let searchBar: UIButton = {
        let search = UIButton()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.backgroundColor = .init(red: 0.45, green: 0.63, blue: 0.95, alpha: 1.00)
        search.setTitle("Click for city search", for: .normal)
        search.layer.cornerRadius = 23
        search.titleLabel?.numberOfLines = 0
        search.titleLabel?.adjustsFontSizeToFitWidth = true
        search.titleLabel?.textAlignment = .center
        search.titleLabel?.font = UIFont.init(name: "Quicksand-Regular", size: 20)
        return search
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .init(red: 0.36, green: 0.64, blue: 0.77, alpha: 1.00)
        return tableView
    }()
    
    let disposeBag = DisposeBag()
    var viewModel = MainViewControllerViewModelImpl(databaseManager: DatabaseManager(), networkManager: NetworkManager())
    var weatherResponse = WeatherResponse(coord: Coordinates(lon: 45.5550, lat: 18.6955), main: CurrentWeather(temp: 0, humidity: 0), weather: [Weather](), id: 0, name: "Osijek")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchBar)
        view.backgroundColor = .init(red: 0.43, green: 0.45, blue: 0.47, alpha: 1.00)
        searchBar.addTarget(self, action: #selector(pushToSearchBarView), for: .touchUpInside)
        setupUI()
        setupSubscriptions()
        initializeDataStatusObservable().disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        viewModel.updateData()
    }
    
    func setupUI() {
        configureTableView()
        setupConstraints()
    }
    
    @objc func pushToSearchBarView() {
        let vc = SearchCityViewController(weatherResponse: weatherResponse)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func initializeDataStatusObservable() -> Disposable {
        viewModel.cityDataStatusObservable
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (status) in
                if status {
                    self.tableView.reloadData()
                }
            })
    }
    
    func initializeSearchBarSubject(for subject: PublishSubject<()>) -> Disposable{
        return subject
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.pushToSearchBarView()
            })
    }
    
    func setupSubscriptions() {
        initializeSearchBarSubject(for: viewModel.searchBarSubject).disposed(by: disposeBag)
    }
    
    func setupConstraints(){
        searchBar.snp.makeConstraints{(maker) in
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(50)
            maker.height.equalTo(50)
        }
        tableView.snp.makeConstraints { (maker) in
            maker.bottom.trailing.leading.equalToSuperview()
            maker.top.equalTo(searchBar.snp.bottom)
        }
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MainViewTableViewCell.self, forCellReuseIdentifier: Cells.mainCell)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.dataSource.count == 0 {
            return 1
        } else {
            return viewModel.dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: HourlyViewController
        if viewModel.dataSource.count == 0 {
            vc = HourlyViewController(weatherResponse: weatherResponse)
        } else {
            vc = HourlyViewController(weatherResponse: viewModel.dataSource[indexPath.row])
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.mainCell) as! MainViewTableViewCell
        if viewModel.dataSource.count == 0 {
            cell.configure(cityWeather: "Osijek")
        } else {
            var cityWeather = viewModel.dataSource[indexPath.row]
            cityWeather.name = (cityWeather.name! as NSString).replacingOccurrences(of: "+", with: " ")
            cell.configure(cityWeather: cityWeather.name!)
        }
        return cell
    }
}
