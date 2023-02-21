//
//  WeatherManager.swift
//  Clima
//
//  Created by Никита Юрковский on 18.02.23.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ wetherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
    
    
    struct WeatherManager {
        let weatherURL = "https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=ebfac4bfd2e624b1b3241e800a8f45c3&units=metric"
        //"https://api.openweathermap.org/data/2.5/weather?appid=ebfac4bfd2e624b1b3241e800a8f45c3&&units=metric"
        
        var delegate: WeatherManagerDelegate?
        
        func fetchWeather(cityName: String) {
            let urlString = "\(weatherURL)&q=\(cityName)"
            performRequest(urlString: urlString)
        }
        
        func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
            let urlString = "\(weatherURL)&lat=\(latitude)&lon\(longitude)"
            performRequest(urlString: urlString)
        }
        
        
        func performRequest(urlString: String) {
            // 1. Create URL
            if let url = URL(string: urlString) {
                
                // 2. Create a URLSession
                let session = URLSession(configuration: .default)
                // 3. Give the session a task
                //let tast = session.dataTask(with: url, completionHandler: handle(data: response: error:))
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    
                    if let safeData = data {
                        if let weather = self.parseJSON(safeData) {
                            self.delegate?.didUpdateWeather(self, weather: weather)
                        }
                    }
                }
                // 4. Start the task
                task.resume()
            }
        }
        
        //    func handle(data: Data?, response: URLResponse?, error: Error?) {
        //        if error != nil {
        //            print(error!)
        //            return
        //        }
        //
        //        if let safeData = data {
        //            let dataString = String(data: safeData, encoding: .utf8)
        //            print(dataString!)
        //        }
        //    }
        
        func parseJSON(_ weatherData: Data) -> WeatherModel? {
            let decoder = JSONDecoder()
            do {
                let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
                print(decodeData.name)
                let temp = decodeData.main.temp
                print(decodeData.weather[0].description)
                let id = decodeData.weather[0].id
                let name = decodeData.name
                
                let weather = WeatherModel(conditionId: id, cityName: name, tempetarure: temp)
                return weather
                
            } catch {
                delegate?.didFailWithError(error: error)
                return nil
            }
        }
}
