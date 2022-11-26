//
//  WeatherManager.swift
//  Clima
//
//  Created by Kelvin KUCH on 04.10.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
//    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=62aa6aef4cf8d42b194db187cba28147&units=metric&q="
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=62aa6aef4cf8d42b194db187cba28147&units=metric&q="
        let urlString = "\(weatherURL)\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(longitude long: Double, latitude lat: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)4&appid=62aa6aef4cf8d42b194db187cba28147"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        // 1. Creating a URL
        if let url = URL(string: urlString) {
            
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Create a session task
            let task = session.dataTask(with: url) { (data, response, error) -> Void in
                if error != nil {
                    print("[!] Error: \(error!)")
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let parsedWeatherData = self.parseJSON(safeData) {
                        print("\n======parsedWeatherData: \(parsedWeatherData)\n\n====")
                        self.delegate?.didUpdateWeather(self, parsedWeatherData)
                    }
                }
            }
            
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let cityName = decodeData.name
            let temperature = decodeData.main.temp
            let weatherModel = WeatherModel(conditionID: id, cityName: cityName, temperature: temperature)
            print("Condition Name:\(weatherModel.conditionName)")
            print("Condition temp stringified:\(weatherModel.temperatureString)")
            return weatherModel
        } catch {
            delegate?.didFailWithError(error: error)
            print("[!]\(error)")
            return nil
        }
    }
}
