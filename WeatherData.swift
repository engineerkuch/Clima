//
//  WeatherD.swift
//  Clima
//
//  Created by Kelvin KUCH on 13.10.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//


struct WeatherData: Decodable {
    let name: String
    let main: Main
    let visibility: Int
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let description: String
    let id: Int
}
