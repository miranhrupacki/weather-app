//
//  HourlyWeatherHeaderCell.swift
//  weather-app
//
//  Created by Miran Hrupački on 01/06/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation
import UIKit

class HourlyWeatherHeaderCell: UITableViewHeaderFooterView {
    let icon: UIImageView = {
         let image = UIImageView ()
         image.translatesAutoresizingMaskIntoConstraints = false
         image.clipsToBounds = true
         return image
     }()
     
     let nameLabel: UILabel = {
         let name = UILabel()
         name.translatesAutoresizingMaskIntoConstraints = false
         name.numberOfLines = 0
         name.adjustsFontSizeToFitWidth = true
         name.textColor = .black
         name.font = UIFont.init(name: "Quicksand-Bold", size: 20)
         name.textAlignment = .center
         return name
     }()
     
     let temperatureLabel: UILabel = {
         let temp = UILabel()
         temp.translatesAutoresizingMaskIntoConstraints = false
         temp.font = UIFont.init(name: "Quicksand-Bold", size: 20)
         temp.layer.shadowColor = UIColor.black.cgColor
         temp.layer.shadowRadius = 3.0
         temp.layer.shadowOpacity = 1.0
         temp.layer.shadowOffset = CGSize(width: 4, height: 4)
         temp.layer.masksToBounds = false
         temp.textAlignment = .center
         return temp
     }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
     
     required init?(coder: NSCoder){
         fatalError("init(coder:) has not been implemented")
     }
     
     func setupUI(){
         contentView.addSubview(nameLabel)
         contentView.addSubview(temperatureLabel)
         contentView.addSubview(icon)
         contentView.backgroundColor = .init(red: 0.36, green: 0.64, blue: 0.77, alpha: 1.00)
         
         setupConstraints()
     }
     
     func setupConstraints(){
        
        nameLabel.snp.makeConstraints{(maker) in
            maker.top.equalToSuperview().inset(20)
            maker.leading.trailing.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints{(maker) in
            maker.top.equalTo(nameLabel.snp.bottom).inset(-75)
            maker.leading.trailing.equalToSuperview()
        }
        
        icon.snp.makeConstraints{(maker) in
            maker.top.equalTo(temperatureLabel.snp.bottom).inset(-75)
            maker.leading.trailing.equalToSuperview().inset(155)
        }
    }
     
    func configure(hourlyWeather: HourlyWeatherResponse, weatherResponse: WeatherResponse){
        let temperature = (hourlyWeather.hourly[0].temp! - 273.15).rounded()
        icon.image = UIImage(named: "\(weatherResponse.weather[0].icon)")
        nameLabel.text = weatherResponse.name
        temperatureLabel.text = "\(temperature)° C"
     }
}
