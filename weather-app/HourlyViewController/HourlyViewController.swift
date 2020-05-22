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
    
    let viewModel: HourlyViewModel = {
        let viewModel = HourlyViewModelImpl(networkManager: NetworkManager())
        return viewModel
    }()
    
    let loaderIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    let disposeBag = DisposeBag()
    var lat = 51.5074
    var lon = 0.1278
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.loadData()
        viewModel.initializeLoadDataSubject().disposed(by: disposeBag)
        inizializeDataStatusObservable().disposed(by: disposeBag)
        initializeAlertObservable().disposed(by: disposeBag)
        initializeLoaderObservable().disposed(by: disposeBag)
    }
    
    func setupUI(){
        configureTableView()
        setupConstraints()
    }
    
    private func initializeAlertObservable() -> Disposable{
        viewModel.alertObservable
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [unowned self] type in
                self.showAlertWith(title: "Hourly weather network error", message: "Weather couldn't load")
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
        viewModel.hourlyWeatherDataStatusObservable
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (status) in
                if status {
                    self.tableView.reloadData()
                }
            })
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
        if viewModel.dataSource == nil {
            return 0
        } else {
            return viewModel.screenData?.hourly.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.hourlyCell) as! HourlyTableViewCell
        
        let hourlyWeather = viewModel.dataSource[indexPath.row]
        cell.configure(hourlyWeather: hourlyWeather)
        
        return cell
    }
}
