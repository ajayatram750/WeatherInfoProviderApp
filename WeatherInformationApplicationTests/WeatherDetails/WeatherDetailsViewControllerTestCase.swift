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
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        if let v = sb.instantiateViewController(withIdentifier: "WeatherDetailsViewController") as? WeatherDetailsViewController {
            vc = v
            _ = vc?.view
            XCTAssertNotNil(vc?.viewWillAppear(true))
            XCTAssertEqual(vc?.title, "Weather Details")
            XCTAssertEqual(vc?.addressDetailLabel.layer.borderWidth, 1)
            XCTAssertEqual(vc?.addressDetailLabel.layer.borderColor, UIColor.black.cgColor)
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testReloadCollectionViewWithData() {
        vc?.reloadCollectionViewWithData(nil)
        XCTAssertEqual(8, vc?.weatherInfoDataArray.count)
        vc?.weatherInfocollectionView.reloadData()
        let count = vc?.collectionView((vc?.weatherInfocollectionView)!, numberOfItemsInSection: 0)
        XCTAssertEqual(count, vc?.weatherInfoDataArray.count)
        
        let count1 = vc?.numberOfSectionsInCollectionView(collectionView: (vc?.weatherInfocollectionView)!)
        XCTAssertEqual(count1, 1)
    }
}
