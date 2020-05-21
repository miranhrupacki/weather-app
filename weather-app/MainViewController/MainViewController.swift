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
        search.setTitle("Click here to search for other cities", for: .normal)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchButton)
        view.addSubview(currentWeatherButton)
        view.backgroundColor = .init(red: 0.43, green: 0.45, blue: 0.47, alpha: 1.00)
        
        currentWeatherButton.addTarget(self, action: #selector(pushToDefaultCityView), for: .touchUpInside)
        // Do any additional setup after loading the view.
        setupUI()
        setupSubscriptions()
    }
    
    func setupUI(){
        setupConstraints()
    }
    
    @objc func pushToDefaultCityView() {
        let vc = ViewController(networkManager: NetworkManager())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupSubscriptions() {
    }
    
    func setupConstraints(){
        
        searchButton.snp.makeConstraints{(maker) in
            maker.top.equalTo(view.safeAreaLayoutGuide).inset(100)
            maker.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(50)
            maker.height.equalTo(150)
        }
        
        currentWeatherButton.snp.makeConstraints{(maker) in
            maker.top.equalTo(searchButton.snp.bottom).inset(-100)
            maker.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(50)
            maker.height.equalTo(150)
        }
    }
}
