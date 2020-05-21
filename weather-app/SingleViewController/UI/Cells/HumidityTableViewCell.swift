//
//  HumidityTableViewCell.swift
//  weather-app
//
//  Created by Miran Hrupački on 20/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit

class HumidityTableViewCell: UITableViewCell {
    
    let humidityLabel: UILabel = {
        let humidity = UILabel()
        humidity.translatesAutoresizingMaskIntoConstraints = false
        humidity.numberOfLines = 0
        humidity.adjustsFontSizeToFitWidth = true
        humidity.textColor = .black
        humidity.font = UIFont.init(name: "Quicksand-Bold", size: 20)
        return humidity
    }()
    
    internal var id: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(humidityLabel)
        setupConstraints()
        contentView.backgroundColor = .init(red: 0.36, green: 0.64, blue: 0.77, alpha: 1.00)
    }
    
    func configure(humidity: Int){
        humidityLabel.text = "Humidity: \(humidity)%"
    }
    
    func setupConstraints(){
        humidityLabel.snp.makeConstraints{(maker) in
            maker.top.bottom.equalToSuperview()
            maker.centerX.equalToSuperview()
            maker.height.equalTo(100)
        }
    }
}
