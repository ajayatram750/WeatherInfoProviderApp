//
//  WeatherDetailsCollectionViewCell.swift
//  WeatherInformationApplication
//
//  Created by 01HW1182974 on 28/02/19.
//  Copyright © 2019 TCS. All rights reserved.
//

import UIKit

class WeatherDetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var subjectValueLabel: UILabel!
    
    // Initialization code
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subjectValueLabel.layer.cornerRadius = 5.0
        self.subjectValueLabel.layer.masksToBounds = true
    }
}
