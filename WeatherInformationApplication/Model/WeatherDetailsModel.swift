//
//  WeatherDetailsModel.swift
//  WeatherInformationApplication
//
//  Created by 01HW1182974 on 28/02/19.
//  Copyright © 2019 TCS. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    func decodeWrapper<T>(key: K, defaultValue: T) throws -> T
        where T : Decodable {
            return try decodeIfPresent(T.self, forKey: key) ?? defaultValue
    }
}

struct WeatherDetailsModel: Decodable {
    
    let id: Int?
    let main: MainModel?
    let weatherInfo: [WeatherInfoModel]?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case weatherInfo = "weather"
        case name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        main = try values.decodeIfPresent(MainModel.self, forKey: .main)
        weatherInfo = try values.decodeWrapper(key: .weatherInfo , defaultValue : [])
        name = try values.decodeIfPresent(String.self, forKey: .name)
        
    }
}

struct MainModel: Codable {
    let temp: Double?
    let pressure: Double?
    let humidity: Double?
    let tempMin: Double?
    let tempMax: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case pressure
        case humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        temp = try values.decodeIfPresent(Double.self, forKey: .temp)
        pressure = try values.decodeIfPresent(Double.self, forKey: .pressure)
        humidity = try values.decodeIfPresent(Double.self, forKey: .humidity)
        tempMin = try values.decodeIfPresent(Double.self, forKey: .tempMin)
        tempMax = try values.decodeIfPresent(Double.self, forKey: .tempMax)
    }
}

struct WeatherInfoModel: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        main = try values.decodeIfPresent(String.self, forKey: .main)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
    }
}

