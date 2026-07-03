//
//  Weather.swift
//  WeatherNetwork
//
//  Created by Survisreevarshith.10852498 on 18/06/26.
//

import Foundation


struct WeatherResponse: Codable {
    let weather: [Weather]?
    let main: Main?
    let wind: Wind?
    let name: String?
    let sys: Sys?
    let base: String?
    let cod: Int?
    let timezone: Int?

}

struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct Main: Codable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
    }
}

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

struct Sys: Codable {
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}


struct WeatherRequest{
    let city: String
    let temp: Double?
}

