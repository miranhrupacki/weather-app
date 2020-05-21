//
//  CityNameTableViewCell.swift
//  weather-app
//
//  Created by Miran Hrupački on 19/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit

class CityNameTableViewCell: UITableViewCell {
    
    let cityLabel: UILabel = {
        let city = UILabel()
        city.translatesAutoresizingMaskIntoConstraints = false
        city.numberOfLines = 0
        city.adjustsFontSizeToFitWidth = true
        city.textColor = .black
        return city
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
        contentView.addSubview(cityLabel)
        setupConstraints()
    }
    
    func configure(name: String){
        cityLabel.text = name
    }
    
    func setupConstraints(){
        cityLabel.snp.makeConstraints{(maker) in
            maker.top.equalToSuperview().inset(15)
            maker.leading.equalToSuperview().inset(15)
            maker.trailing.equalToSuperview().inset(12)
        }
    }
}
