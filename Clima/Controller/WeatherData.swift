//
//  WeatherData.swift
//  Clima
//
//  Created by Vineet Mahali on 07/07/20.
//  Copyright © 2020 Aditaya Rana. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}
struct Main: Decodable {
    let temp: Double
    
}

struct Weather: Decodable {
    let description: String
    let id: Int
}
