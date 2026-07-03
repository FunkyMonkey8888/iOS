//
//  ViewModel.swift
//  WeatherNetwork
//
//  Created by Survisreevarshith.10852498 on 18/06/26.
//

import Foundation
import Combine

class WeatherViewModel:ObservableObject {
    @Published var temperature:String = ""
    @Published var city:String = ""
    @Published var errorMsg:String? = ""

    @Published var weather: WeatherResponse?

    private let weatherService: WeatherService = WeatherService()
    init(temperature: String, city: String) {
        self.temperature = temperature
        self.city = city
    }
    init () {
        fetchWeather(city: "Hyderabad")
    }

    func fetchData(city: String) {

        weatherService.fetchData(city){ temp, name in
            DispatchQueue.main.async {
                self.temperature = "\(temp.rounded())"
                self.city = name
            }
        }
    }

    func fetchWeather(city:String){
        weatherService.fetchWeather(for: city, completion: { [weak self] result in
            DispatchQueue.main.async {
                self?.temperature = "\(result.main?.temp?.rounded(), default: "25")"
                self?.city = city

                self?.weather = result
            }
        })
    }
}
