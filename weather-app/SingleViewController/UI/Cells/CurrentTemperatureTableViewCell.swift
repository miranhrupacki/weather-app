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
    temp.font = UIFont.init(name: "Quicksand-Regular", size: 20)
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
    }
    
    func configure(temperature: Double){
        cityTemp.text = "\(temperature)"
    }
    
    func setupConstraints(){
        cityTemp.snp.makeConstraints{(maker) in
            maker.top.equalToSuperview().inset(15)
            maker.leading.equalToSuperview().inset(15)
            maker.trailing.equalToSuperview().inset(12)
        }
    }
}
