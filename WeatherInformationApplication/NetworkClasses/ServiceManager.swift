//
//  ServiceManager.swift
//  WeatherInformationApplication
//
//  Created by 01HW1182974 on 28/02/19.
//  Copyright © 2019 TCS. All rights reserved.
//

import Foundation

class ServiceManager {
    
    var urlSession:URLSession?
    
    private static var sharedInstance: ServiceManager = {
        let serviceManager = ServiceManager()
        
        let config = URLSessionConfiguration.default
        serviceManager.urlSession = URLSession(configuration: config)
        
        return serviceManager
    }()
    
    
    
    class func shared() -> ServiceManager {
        return sharedInstance
    }
    
    func getWeatherDetailsWebServiceCall(urlString: String, completion:@escaping (_ response: WeatherDetailsModel?,_ errorMessage :String?) -> Void)  {
        
        guard let url = URL(string: urlString) else {
            completion(nil,"Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        // make the request
        let task = self.urlSession?.dataTask(with: urlRequest) {
            (data, response, error) in
            
            // check for any errors
            guard error == nil else {
                completion(nil,"No response from server, Please try again!")
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                completion(nil,"Error: did not receive data")
                return
            }
            
            do {
                guard let response = try JSONDecoder().decode(WeatherDetailsModel.self, from: responseData) as WeatherDetailsModel?
                    else {
                        completion(nil,"Error trying to convert data to JSON")
                        return
                }
                completion(response,nil)
                
            } catch let error {
                
                completion(nil,error.localizedDescription)
                return
            }
        }
        task?.resume()
    }
}
