//
//  MainViewTableViewCell.swift
//  weather-app
//
//  Created by Miran Hrupački on 29/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation
import UIKit

class MainViewTableViewCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.numberOfLines = 0
        name.adjustsFontSizeToFitWidth = true
        name.textColor = .black
        name.font = UIFont.init(name: "Quicksand-Bold", size: 20)
        return name
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
        contentView.backgroundColor = .init(red: 0.36, green: 0.64, blue: 0.77, alpha: 1.00)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        
        nameLabel.snp.makeConstraints{(maker) in
            maker.top.bottom.leading.equalToSuperview().inset(20)
        }
    }
    
    func configure(cityWeather: String){
        nameLabel.text = cityWeather
    }
}
