//
//  SearchCityTableViewCell.swift
//  weather-app
//
//  Created by Miran Hrupački on 27/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation
import UIKit

class SearchCityTableViewCell: UITableViewCell {
    
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
        contentView.backgroundColor = .init(red: 0.36, green: 0.64, blue: 0.77, alpha: 1.00)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        
        nameLabel.snp.makeConstraints{(maker) in
            maker.top.bottom.leading.equalToSuperview().inset(20)
        }
        
        temperatureLabel.snp.makeConstraints{(maker) in
            maker.top.bottom.equalToSuperview()
            maker.leading.equalTo(nameLabel.snp.trailing).inset(-20)
        }
        
        icon.snp.makeConstraints{(maker) in
            maker.top.bottom.equalToSuperview()
            maker.leading.equalTo(temperatureLabel.snp.trailing).inset(-20)
        }
    }
    
    func configure(cityWeather: CityByNameView){
        let temperature = (cityWeather.temperature - 273.15).rounded()
        icon.image = UIImage(named: "\(cityWeather.image)")
        nameLabel.text = cityWeather.name
        temperatureLabel.text = "\(temperature)° C"
    }
}
