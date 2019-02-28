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
    var finalDataArray : NSMutableArray = NSMutableArray()
    
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
        self.getAddressFromLatLon(latitude:self.latitude!, withLongitude:self.longitude!)
        
        // Call Get Weather webservice
        self.getWeatherInformationWebserviceCall()
        
    }
    
    // MARK: - Webservice Calls
    
    /*
     Method Name : getWeatherInformationWebserviceCall
     Purpose     : get Weather Information Webservice Call
     Paramater   : None
     Return      : None
     */
    func getWeatherInformationWebserviceCall() {
        
        self.showActivityIndicator()
        
        let urlString = String(format: "https://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&APPID=db98ccbb9bd290454acb708501e30097",latitude!,longitude! )
        
        ServiceManager.shared().getWeatherDetailsWebServiceCall(urlString: urlString) { (responseData, error) in
            
             DispatchQueue.main.async {
                self.hideActivityIndicator()
            }
            
            if let errorMessage = error{
                //Show Error Alert
                self.showAlert(title: "Error", message: errorMessage)
            }
            
            guard let weatherDetails = responseData else{return}
            //self.getAddressFromLatLon(latitude:self.latitude!, withLongitude:self.longitude!)
            
            self.reloadCollectionViewWithData(data: weatherDetails)
            
        }
    }
    
    /*
     Method Name : getAddressFromLatLon
     Purpose     : get Address from latitude & Longitude
     Paramater   : latitude & longitude
     Return      : None
     */
    func getAddressFromLatLon(latitude: String, withLongitude longitude: String) {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(latitude)")!
        //21.228124
        let lon: Double = Double("\(longitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                
                if let pm = placemarks {
                    
                    if pm.count > 0 {
                        
                        let pm = placemarks![0]
                        var addressString : String = ""
                        
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
                        
                        self.addressDetailLabel.text = addressString
                    }
                }
        })
    }
    
    func reloadCollectionViewWithData(data:WeatherDetailsModel){
        
        self.finalDataArray.removeAllObjects()
        
        self.finalDataArray.add(data.name ?? "")
        self.finalDataArray.add(String(data.main?.temp ?? 0))
        self.finalDataArray.add(String(data.main?.tempMin ?? 0))
        self.finalDataArray.add(String(data.main?.tempMax ?? 0))
        self.finalDataArray.add(String(data.main?.humidity ?? 0))
        self.finalDataArray.add(String(data.main?.pressure ?? 0))
        self.finalDataArray.add(self.latitude ?? "")
        self.finalDataArray.add(self.longitude ?? "")
        
        DispatchQueue.main.async {
            self.weatherInfocollectionView.dataSource = self
            self.weatherInfocollectionView.reloadData()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//Extensions for UICollection
extension WeatherDetailsViewController : UICollectionViewDataSource{
    
    //MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //return number of sections in collection view
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return number of rows in section
        return self.subjectItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! WeatherDetailsCollectionViewCell
        
        cell.subjectLabel.text = self.subjectItems[indexPath.item]
        cell.subjectValueLabel.text = self.finalDataArray[indexPath.item] as? String
        return cell
    }
}
