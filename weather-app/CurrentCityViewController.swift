//
//  CurrentCityViewController.swift
//  weather-app
//
//  Created by Miran Hrupački on 19/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CurrentCityViewController: UIViewController{
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .init(red: 0.36, green: 0.64, blue: 0.77, alpha: 1.00)
        return tableView
    }()
    
    let viewModel: CurrentCityViewModel
    let disposeBag = DisposeBag()
    let loaderIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        viewModel.loadData()
        viewModel.initializeLoadDataSubject().disposed(by: disposeBag)
        inizializeDataStatusObservable().disposed(by: disposeBag)
        initializeAlertObservable().disposed(by: disposeBag)
        initializeLoaderObservable().disposed(by: disposeBag)
    }
    
    init(weatherResponse: WeatherResponse) {
        viewModel = CurrentCityViewModelImpl(networkManager: NetworkManager(), weatherResponse: weatherResponse)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func inizializeDataStatusObservable() -> Disposable {
        viewModel.weatherDataStatusObservable
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
            maker.bottom.trailing.leading.top.equalToSuperview()
        }
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CurrentCityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.screenData == nil {
            return 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.cityCell) as! SearchCityTableViewCell
        
        let cityWeather = viewModel.screenData ?? nil
        cell.configure(cityWeather: cityWeather!)
        
        return cell
    }
}

