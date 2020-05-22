//
//  DescriptionTableViewCell.swift
//  weather-app
//
//  Created by Miran Hrupački on 20/05/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
    
    let descriptionLabel: UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.numberOfLines = 0
        description.adjustsFontSizeToFitWidth = true
        description.font = UIFont.init(name: "Quicksand-Bold", size: 20)
        description.textColor = .black
        return description
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(descriptionLabel)
        setupConstraints()
        contentView.backgroundColor = .init(red: 0.36, green: 0.64, blue: 0.77, alpha: 1.00)
    }
    
    func configure(description: String){
        descriptionLabel.text = description
    }
    
    func setupConstraints(){
        descriptionLabel.snp.makeConstraints{(maker) in
            maker.top.bottom.equalToSuperview()
            maker.centerX.equalToSuperview()
            maker.height.equalTo(100)
        }
    }
}
