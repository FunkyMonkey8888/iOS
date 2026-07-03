//
//  WeatherService.swift
//  WeatherNetwork
//
//  Created by Survisreevarshith.10852498 on 18/06/26.
//

import Foundation


class WeatherService {

    private let urlString = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "YOUR_API_KEY"



    func fetchData(_ city:String, completion: @escaping (Double, String) -> Void) {



        guard let url = URL(string: urlString) else {return}

        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("DEBUG: Failed to fetch data: \(error.localizedDescription)")

                return
            }
            if let data = data {
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] ?? [:]

                let value = jsonObject?["main"] as? [String:Any]
                var temp = value?["temp"] as? Double
                temp = (temp ?? 25) - 273.15
                let name = jsonObject?["name"] as? String

//                DispatchQueue.main.async {
//                    self.temperature = "\(((temp ?? 25) - 273.15).rounded())°C"
//
//
//                    let name = jsonObject?["name"] as? String
//                    self.city = name ?? ""
//
//                }
                print("API for City: \(name ?? "")")
                print("Temp: \(temp?.rounded() ?? 0)°C")
                print("Received: \(data)")

                completion(temp ?? 25, name ?? "")
            }
        }).resume()

    }

    func fetchWeather(for city: String, completion: @escaping (WeatherResponse) -> Void) {
        var components = URLComponents(string: urlString )
        components?.queryItems = [
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "lang", value: "en"),
        ]

        guard let url = components?.url else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)

                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
//                print("Error: \(httpResponse.statusCode) \(httpResponse)")
                print("DEBUG: Error occured\n " + NetworkError.invalidResponse.localizedDescription)
                return
            }
            
            if let data = data {
                guard let weather = try? JSONDecoder().decode(WeatherResponse.self, from: data) else {
                    print("DEBUG: Error occured\n " + NetworkError.decodingError.localizedDescription)
                    return
                }
                print("API for City: \(weather.name ?? "")")
                print(weather)
                completion(weather)
            }

        }.resume()

    }
}
