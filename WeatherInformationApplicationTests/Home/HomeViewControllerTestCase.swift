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
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        if let v = sb.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            vc = v
            _ = vc?.view
            XCTAssertNotNil(vc?.viewWillAppear(true))
            XCTAssertEqual(vc?.title, "Home")
            XCTAssertTrue(vc?.errorLabelForLatLon.isHidden ?? false)
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
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
    
    func testMyTextField_ShouldAllowAlphabeticCharacters() {
        // Call through field.delegate, not through vc
        if let result = vc?.textField((vc?.latitudeTextField)!, shouldChangeCharactersIn: NSMakeRange(0, 1), replacementString: "a") {
            XCTAssertFalse(result)
        }
        if let result = vc?.textField((vc?.latitudeTextField)!, shouldChangeCharactersIn: NSMakeRange(0, 1), replacementString: "6") {
            XCTAssertTrue(result)
        }
    }
}
