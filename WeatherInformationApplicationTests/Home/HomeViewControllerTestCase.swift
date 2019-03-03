//
//  HomeViewControllerTestCase.swift
//  WeatherInformationApplication
//
//  Created by 01HW1182974 on 03/03/19.
//  Copyright © 2019 TCS. All rights reserved.
//

import XCTest
import CoreLocation
@testable import WeatherInformationApplication

class HomeViewControllerTestCase: XCTestCase {
    var vc: HomeViewController?
    
    override func setUp() {
        
        super.setUp()
        let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
        if let homeViewVC = mainSB.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            vc = homeViewVC
            _ = vc?.view
            XCTAssertNotNil(vc?.viewWillAppear(true))
            XCTAssertEqual(vc?.title, "Home")
            XCTAssertTrue(vc?.errorLabelForLatLon.isHidden ?? false)
        }
    }
    
    //Check City Input and handle geo response
    func testGetWeatherDetailsButtonClicked() {
        vc?.getWeatherDetailsButtonClicked(UIButton())
        vc?.latitudeTextField.text = "latitudeTextField"
        vc?.longitudeTextField.text = "longitudeTextField"
        vc?.getWeatherDetailsButtonClicked(UIButton())
        vc?.promptForCityInput()
        vc?.handleGeocodeAddressResponse([])
        XCTAssertFalse(vc?.errorLabelForLatLon.isHidden ?? true)
        
        XCTAssertEqual(vc?.backgroundView.layer.borderWidth, 1)
        XCTAssertEqual(vc?.backgroundView.layer.borderColor, UIColor.black.cgColor)
        
        XCTAssertEqual(vc?.getLatAndLongButton.layer.borderWidth, 1)
        XCTAssertEqual(vc?.getLatAndLongButton.layer.borderColor, UIColor.black.cgColor)
        
    }
    
    //Check Textfield input
    func testMyTextField_ShouldAllowAlphabeticCharacters() {
        if let result = vc?.textField((vc?.latitudeTextField)!, shouldChangeCharactersIn: NSMakeRange(0, 1), replacementString: "a") {
            XCTAssertFalse(result)
        }
        if let result = vc?.textField((vc?.latitudeTextField)!, shouldChangeCharactersIn: NSMakeRange(0, 1), replacementString: "6") {
            XCTAssertTrue(result)
        }
    }
}
