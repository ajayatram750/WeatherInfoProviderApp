//
//  WeatherInformationApplicationTests.swift
//  WeatherInformationApplicationTests
//
//  Created by 01HW1182974 on 28/02/19.
//  Copyright © 2019 TCS. All rights reserved.
//

import XCTest
@testable import WeatherInformationApplication


class WeatherInformationApplicationTests: XCTestCase {
    
    var sessionUnderTest: URLSession!
    
    var weatherDetailVC : WeatherDetailsViewController?
    var homeVC : HomeViewController?
    let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    
    override func setUp() {
        super.setUp()
        weatherDetailVC = WeatherDetailsViewController()
    }
    
    override func tearDown() {
        weatherDetailVC = nil
        super.tearDown()
    }
    
    func testExample() {
        
        let lat = "18.539059"
        let lon = "73.872828"
        let expectedOutput = "Mali and Munjeri"
        
        let urlString = String(format: "https://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&APPID=db98ccbb9bd290454acb708501e30097",lat,lon )
        
        let promise = expectation(description: "Status code: 200")
        guard let url = URL(string: urlString) else {
            XCTFail("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        
        // make the request
        let task = urlSession.dataTask(with: urlRequest) {
            (data, response, error) in
            
            // check for any errors
            guard error == nil else {
                
                XCTFail("Error calling GET on webservice")
                return
            }
            
            guard let responseData = data else {
                
                XCTFail("Error: did not receive data")
                return
            }
            
            do {
                guard let response = try JSONDecoder().decode(WeatherDetailsModel.self, from: responseData) as WeatherDetailsModel?
                    else {
                        
                        XCTFail("Error trying to convert data to JSON")
                        
                        return
                }
               
                promise.fulfill()
                XCTAssertTrue(response.name == expectedOutput,"Incorrect City Name")
                
            } catch {
                
                XCTFail("Error trying to convert data to JSON")
                return
            }
        }
        
        task.resume()
        waitForExpectations(timeout: 15, handler: nil)
    }
    
}

