//
//  WeatherDetailsViewControllerTestCase.swift
//  WeatherInformationApplicationTests
//
//  Created by 01HW1182974 on 03/03/19.
//  Copyright © 2019 TCS. All rights reserved.
//

import XCTest
import CoreLocation
@testable import WeatherInformationApplication

class WeatherDetailsViewControllerTestCase: XCTestCase {
    var vc: WeatherDetailsViewController?
    
    override func setUp() {
        super.setUp()
        let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
        if let WeatherDetailsVC = mainSB.instantiateViewController(withIdentifier: "WeatherDetailsViewController") as? WeatherDetailsViewController {
            vc = WeatherDetailsVC
            _ = vc?.view
            XCTAssertNotNil(vc?.viewWillAppear(true))
            XCTAssertEqual(vc?.title, "Weather Details")
            XCTAssertEqual(vc?.addressDetailLabel.layer.borderWidth, 1)
            XCTAssertEqual(vc?.addressDetailLabel.layer.borderColor, UIColor.black.cgColor)
        }
    }
    
    // Check numberOfItems & numberOfSection in collection view
    func testReloadCollectionViewWithData() {
        vc?.reloadCollectionViewWithData(nil)
        XCTAssertEqual(8, vc?.weatherInfoDataArray.count)
        vc?.weatherInfocollectionView.reloadData()
        let numberOfItems = vc?.collectionView((vc?.weatherInfocollectionView)!, numberOfItemsInSection: 0)
        XCTAssertEqual(numberOfItems, vc?.weatherInfoDataArray.count)
        
        let numberOfSection = vc?.numberOfSectionsInCollectionView(collectionView: (vc?.weatherInfocollectionView)!)
        XCTAssertEqual(numberOfSection, 1)
    }
    
    // Check proper address using Lat & Lon
    func testGetAddressFromLatLon() {
        let expectedOutput = "Lumbini Nagar, Pune, India, 411001 "
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(CLLocation(latitude: Double("18.539059") ?? 0.0, longitude: Double("73.872828") ?? 0.0), completionHandler:
            {(placemarks, error) in
                if error != nil {
                    print("Geodcode fail: \(error!.localizedDescription)")
                }
                let address = WeatherBusinessManager.shared.handleGeoResponse(placemarks)
                XCTAssertTrue(address == expectedOutput,"Incorrect Address details")
        })
    }
    
    // Check proper weather information details
    func testGetWeatherInformationCall() {
        
        let expectedCityName = "Mali and Munjeri"
        let urlString = String(format: "https://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&APPID=db98ccbb9bd290454acb708501e30097","18.539059","73.872828")
        
        WeatherBusinessManager.shared.getWeatherInformationWebserviceCall(url: urlString) { (weatherData, error) in
            
            if let weatherDetails = weatherData{//Success & show data
                XCTAssertTrue(weatherDetails.name == expectedCityName,"Incorrect City Name")
            }
        }
    }
}
