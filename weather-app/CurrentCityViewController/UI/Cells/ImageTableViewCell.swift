//
//  ImageTableViewCell.swift
//  weather-app
//
//  Created by Miran Hrupački on 19/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    let weatherImageView: UIImageView = {
        let weatherImage = UIImageView()
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.clipsToBounds = true
        weatherImage.layer.cornerRadius = 20
        return weatherImage
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
        contentView.addSubview(weatherImageView)
        contentView.backgroundColor = .init(red: 0.36, green: 0.64, blue: 0.77, alpha: 1.00)
        setupConstraints()
    }
    
    func configure(image: String, weather: WeatherCellItem){
        weatherImageView.image = UIImage(named: image)
    }
    
    func setupConstraints(){
        weatherImageView.snp.makeConstraints{(maker) in
            maker.top.bottom.equalToSuperview()
            maker.centerX.equalToSuperview()
        }
    }
}

