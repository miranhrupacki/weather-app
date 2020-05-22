//
//  HourlyTableViewCell.swift
//  weather-app
//
//  Created by Miran Hrupački on 21/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {

    let hourlyLabel: UILabel = {
        let movieTitleLabel = UILabel()
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        movieTitleLabel.numberOfLines = 0
        movieTitleLabel.adjustsFontSizeToFitWidth = true
        movieTitleLabel.font = UIFont.init(name: "Quicksand-Bold", size: 17)
        movieTitleLabel.textColor = .black
        return movieTitleLabel
    }()
    
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
        return temp
    }()
    
    let date = Date()
    var dateFormatter = DateFormatter()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(nameLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(icon)
        contentView.addSubview(hourlyLabel)
        contentView.backgroundColor = .init(red: 0.36, green: 0.64, blue: 0.77, alpha: 1.00)

        setupConstraints()
    }
    
    func setupConstraints(){
        
        nameLabel.snp.makeConstraints{(maker) in
            maker.top.bottom.leading.equalToSuperview().inset(-20)
        }
        
        temperatureLabel.snp.makeConstraints{(maker) in
            maker.top.bottom.equalToSuperview()
            maker.leading.equalTo(nameLabel.snp.trailing).inset(-20)
        }
        
        hourlyLabel.snp.makeConstraints{(maker) in
            maker.top.bottom.equalToSuperview()
            maker.leading.equalTo(temperatureLabel.snp.trailing).inset(-20)
        }
        
        icon.snp.makeConstraints{(maker) in
            maker.top.bottom.equalToSuperview()
            maker.leading.equalTo(hourlyLabel.snp.trailing).inset(-20)
        }
    }
    
    func configure(hourlyWeather: HourlyWeatherView){
        dateFormatter.dateFormat = "HH"
        let date = Date(timeIntervalSince1970: Double(hourlyWeather.date))
        let temperature = (hourlyWeather.temperature - 273.15).rounded()
        hourlyLabel.text = "\(dateFormatter.string(from: date))"
        icon.image = UIImage(named: "\(hourlyWeather.image)")
        nameLabel.text = hourlyWeather.name
        temperatureLabel.text = "\(temperature)° C"
       }
}
