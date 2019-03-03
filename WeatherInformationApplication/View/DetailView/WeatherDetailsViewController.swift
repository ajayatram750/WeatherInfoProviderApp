//
//  WeatherDetailsViewController.swift
//  WeatherInformationApplication
//
//  Created by 01HW1182974 on 28/02/19.
//  Copyright © 2019 TCS. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherDetailsViewController: UIViewController {
    
    //MARK:- IBOutlet and othe attributs declaration
    
    @IBOutlet weak var addressDetailLabel: UILabel!
    @IBOutlet weak var weatherInfocollectionView: UICollectionView!
    
    var myActivityIndicator = UIActivityIndicatorView()
    var latitude: String?
    var longitude: String?
    var weatherInfoDataArray : NSMutableArray = NSMutableArray()
    
    //cell identifier in the storyboard
    private let reuseIdentifier = "WeatherDetailsCollectionViewCell"
    var subjectItems = ["Location Name","Temparature", "Temp Min", "Temp Max", "Humidity", "Pressure", "Latitude", "Longitude"]
    
    //MARK:- Class life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Weather Details"
        
        addressDetailLabel.layer.borderWidth = 1
        addressDetailLabel.layer.borderColor = UIColor.black.cgColor
        
        // Register cell classes
        let nib = UINib(nibName: "WeatherDetailsCollectionViewCell", bundle: nil)
        self.weatherInfocollectionView?.register(nib, forCellWithReuseIdentifier: "WeatherDetailsCollectionViewCell")
        
        // Get address from lat & lon
        self.getAddressFromLatLon(latitude:self.latitude ?? "", withLongitude:self.longitude ?? "")
        
        // Call Get Weather webservice
        self.getWeatherInformationCall()
    }
    
    // This method used for getting Address from latitude & Longitude
    func getAddressFromLatLon(latitude: String, withLongitude longitude: String) {
        
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(CLLocation(latitude: Double("\(latitude)") ?? 0.0, longitude: Double("\(longitude)") ?? 0.0), completionHandler:
            {(placemarks, error) in
                if error != nil {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                self.addressDetailLabel.text = WeatherBusinessManager.shared.handleGeoResponse(placemarks)
        })
    }
    
    // This method is used for reloading waether data 
    func reloadCollectionViewWithData(_ data: WeatherDetailsModel?){
        
        self.weatherInfoDataArray.removeAllObjects()
        self.weatherInfoDataArray.add(data?.name ?? "")
        self.weatherInfoDataArray.add(String(data?.main?.temp ?? 0))
        self.weatherInfoDataArray.add(String(data?.main?.tempMin ?? 0))
        self.weatherInfoDataArray.add(String(data?.main?.tempMax ?? 0))
        self.weatherInfoDataArray.add(String(data?.main?.humidity ?? 0))
        self.weatherInfoDataArray.add(String(data?.main?.pressure ?? 0))
        self.weatherInfoDataArray.add(self.latitude ?? "")
        self.weatherInfoDataArray.add(self.longitude ?? "")
        DispatchQueue.main.async {
            self.weatherInfocollectionView.reloadData()
        }
    }
    
    // MARK: - Webservice Calls
    
    // This method used for calling Weather Information Webservice Call
    func getWeatherInformationCall() {
        
        //self.showActivityIndicator()
        let urlString = String(format: "https://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&APPID=db98ccbb9bd290454acb708501e30097",latitude ?? "",longitude ?? "" )
        
        WeatherBusinessManager.shared.getWeatherInformationWebserviceCall(url: urlString) { (weatherData, error) in
            DispatchQueue.main.async {
                self.hideActivityIndicator()
            }
            if let errorMessage = error{//Show Error Alert
                self.showAlert(title: "Error", message: errorMessage)
            }
            if let weatherDetails = weatherData{//Success & show data
                self.reloadCollectionViewWithData(weatherDetails)
            }
        }
    }
}

//Extensions for UICollection
extension WeatherDetailsViewController : UICollectionViewDataSource{
    
    //MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1 //return number of sections in collection view
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.weatherInfoDataArray.count //return number of rows in section
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as? WeatherDetailsCollectionViewCell {
            
            cell.subjectLabel.text = self.subjectItems[indexPath.item]
            cell.subjectValueLabel.text = self.weatherInfoDataArray[indexPath.item] as? String
            return cell
        }
        return WeatherDetailsCollectionViewCell()
    }
}
