//
//  Movie.swift
//  WatchIt
//
//  Created by Survisreevarshith.10852498 on 10/06/26.
//

//Model
import Foundation

struct Movie:Decodable{
    let id:UUID = UUID()
    let title:String
    let posterPath:String
    let overview:String
    let rating:Double
    let genre: String
//    let trailerURL: String?
}




struct MovieSection {
    let title: String
    let movies: [Movie]
}
