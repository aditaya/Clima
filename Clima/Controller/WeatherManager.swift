//
//  WeatherManager.swift
//  Clima
//
//  Created by Vineet Mahali on 07/07/20.
//  Copyright © 2020 Aditaya Rana. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
    
}
  
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=468ef82f2e87052869007ee6ab4633aa&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees , longitude: CLLocationDegrees ) {
    let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {  
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData  = data {
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
            
        }
    }
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodeddata = try decoder.decode(WeatherData.self, from: weatherData)
          let cityName = decodeddata.name
            let temperature = decodeddata.main.temp
            let id = decodeddata.weather[0].id
          
            let weather = WeatherModel(conditionId: id, cityName: cityName, temperature: temperature)
           return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
   

    
    
}
