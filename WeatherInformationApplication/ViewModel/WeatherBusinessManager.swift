//
//  WeatherBusinessManager.swift
//  WeatherInformationApplication
//
//  Created by 01HW1182974 on 03/03/19.
//  Copyright © 2019 TCS. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherBusinessManager {
    static let shared = WeatherBusinessManager()
    private init(){}
    
    func handleGeoResponse(_ placemarks: [CLPlacemark]?) -> String{
        
        var addressString = ""
        if let pms = placemarks, pms.count > 0 {
            let pm = pms[0]
            if pm.subLocality != nil {
                addressString = addressString + pm.subLocality! + ", "
            }
            if pm.thoroughfare != nil {
                addressString = addressString + pm.thoroughfare! + ", "
            }
            if pm.locality != nil {
                addressString = addressString + pm.locality! + ", "
            }
            if pm.country != nil {
                addressString = addressString + pm.country! + ", "
            }
            if pm.postalCode != nil {
                addressString = addressString + pm.postalCode! + " "
            }
        }
        return addressString
    }
}
