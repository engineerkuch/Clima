//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading view...")
        // Do any additional setup after loading the view.
        searchTextField.delegate = self
        locationManager.delegate = self
        weatherManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        print("We are ready!")
    }
    
    
    
    
    @IBAction func currentLocationButton(_ sender: UIButton) {
        locationManager.requestLocation()
        
    }
    
}

// MARK: CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations: \(locations)\n\n")
        print("locations.last: \(locations.last!)\n\n")
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            weatherManager.fetchWeather(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[!] Got error! \n\(error)")
    }
}


// MARK: UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        if let currentWeather = searchTextField.text {
            print("\(weatherManager.fetchWeather(cityName: currentWeather))")
            
        }
        searchTextField.endEditing(true)
//        print(searchTextField.text!)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text == "" {
            return true
        } else {
            searchTextField.placeholder = "You have to enter a city name."
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        return true
    }
}


// MARK: WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel) {
        DispatchQueue.main.async { [self] in
            
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print("[!] Error (delegate): \(error)")
    }
}
