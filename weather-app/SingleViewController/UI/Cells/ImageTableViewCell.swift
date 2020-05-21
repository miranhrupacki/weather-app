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
        weatherImage.layer.maskedCorners = [.layerMaxXMaxYCorner, . layerMinXMaxYCorner]
        return weatherImage
    }()
}
