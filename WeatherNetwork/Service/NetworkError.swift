//
//  NetworkError.swift
//  WeatherNetwork
//
//  Created by Survisreevarshith.10852498 on 19/06/26.
//

import Foundation


enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError

    var errorMsg: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid Response"
        case .noData:
            return "No Data"
        case .decodingError:
            return "Decoding Error"
        }
    }
}
