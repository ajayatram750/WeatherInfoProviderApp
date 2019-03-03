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
    
    // This method used for handling Geo Response and pass the data to the view
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
    
    // This method used for getting Weather Information Webservice Call response and pass the data to the view
    func getWeatherInformationWebserviceCall(url:String, completion:@escaping (_ response: WeatherDetailsModel?,_ errorMessage :String?) -> Void)  {
        ServiceManager.shared().getWeatherDetailsWebServiceCall(urlString: url) { (responseData, error) in
            if let errorMessage = error{//Show Error Alert
                completion(nil,errorMessage)
                return
            }
            if let weatherDetails = responseData  {//Success & show data
                completion(weatherDetails,nil)
            }
        }
    }
}
