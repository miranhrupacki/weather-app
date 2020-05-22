//
//  CurrentTemperatureTableViewCell.swift
//  weather-app
//
//  Created by Miran Hrupački on 19/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//


import UIKit

class CurrentTemperatureTableViewCell: UITableViewCell {
    
let cityTemp: UILabel = {
    let temp = UILabel()
    temp.translatesAutoresizingMaskIntoConstraints = false
    temp.font = UIFont.init(name: "Quicksand-Bold", size: 40)
    temp.layer.shadowColor = UIColor.black.cgColor
    temp.layer.shadowRadius = 3.0
    temp.layer.shadowOpacity = 1.0
    temp.layer.shadowOffset = CGSize(width: 4, height: 4)
    temp.layer.masksToBounds = false
    return temp
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
        contentView.addSubview(cityTemp)
        setupConstraints()
        contentView.backgroundColor = .init(red: 0.36, green: 0.64, blue: 0.77, alpha: 1.00)

    }

    func configure(temperature: Double){
        let temperature = (temperature - 273.15).rounded()
        cityTemp.text = "\(temperature)° C"
    }
    
    func setupConstraints(){
        cityTemp.snp.makeConstraints{(maker) in
            maker.top.bottom.equalToSuperview()
            maker.centerX.equalToSuperview()
            maker.height.equalTo(100)
        }
    }
}
