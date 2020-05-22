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
    
    let disposeBag = DisposeBag()
    let loaderIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    let viewModel: CurrentCityViewModel = {
        let viewModel = CurrentCityViewModelImpl(networkManager: NetworkManager())
        return viewModel
    }()
    
    var lat = 45.7621
    var lon = 18.1651
    
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
    
    func setupUI(){
        configureTableView()
        setupConstraints()
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

extension CurrentCityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = viewModel.screenData[indexPath.row]
        
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
