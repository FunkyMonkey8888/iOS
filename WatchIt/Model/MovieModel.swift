//
//  MovieModel.swift
//  WatchIt
//
//  Created by Survisreevarshith.10852498 on 12/06/26.
//

import Foundation
import CoreData
import UIKit
struct MovieModel:Decodable{
    let Title:String
    let Year:String
    let Rated:String
    let Runtime:String
    let Released:String
    let Genre:String
    let Director:String
    let Writer:String
    let Actors:String
    let Plot:String
    let Language:String
    let Country:String
    let Awards:String
    let Poster:String

    let Metascore:String
    let imdbRating:String
}

struct MoviesResponse:Decodable{
    let movies:[MovieModel]
}


class ParseJson{

    func loadMovies() -> [Movie] {
        guard let url = Bundle.main.url(forResource: "Movies", withExtension: "json") else {
            print("movies.json file not found")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(MoviesResponse.self, from: data)

            let mappedMovies = response.movies.map {
                Movie(
                    title: $0.Title,
                    posterPath: $0.Poster,
                    overview: $0.Plot,
                    rating: Double($0.imdbRating) ?? 0.0,
                    genre: $0.Genre.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespaces) ?? $0.Genre
                )
            }

            print("Loaded \(mappedMovies.count) movies")
            return mappedMovies
        } catch {
            print("JSON decode error: \(error)")
            return []
        }
    }
}


class DataManager {
    static let shared = DataManager()
    private init() {}

    var movies: [Movie] = []
    func getMovies() -> [Movie] {
        return movies
    }
    func isMovieSaved(title: String) -> Bool {
        return movies.contains(where: { $0.title == title })
    }
    func saveMovie(_ movie:Movie){
        guard !isMovieSaved(title: movie.title) else { return }
        movies.append(movie)
    }
    func deleteMovie(at index: Int) {
        movies.remove(at: index)
    }
    func deleteMovie(movie: Movie){
        let index = movies.firstIndex(where: { $0.title == movie.title })
        movies.remove(at: index!)
    }
    func getAllMovies() -> [Movie] {
        return movies
    }
}









































//
//class DataManager {
//    static let shared = DataManager()
//
//    init () {
//
//    }
//    private var context: NSManagedObjectContext {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        return appDelegate.persistentContainer.viewContext
//    }
//    func saveMovie(_ movie:Movie){
////        guard !isMovieSaved(movie.id) else { return }
//
//        let watchListMovie = MovieEntity(context: context)
//        watchListMovie.title = movie.title
//        watchListMovie.genre = movie.genre
//        watchListMovie.rating = movie.rating
//        watchListMovie.overview = movie.overview
//        watchListMovie.posterPath = movie.posterPath
//
//        do{
//            print("\(movie.title) is added to watchlist")
//            try context.save()
//        }
//        catch {
//            print("Error: \(error.localizedDescription)")
//        }
//
//
//    }
//
//    func getAllMovies() -> [Movie]{
//        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
//        do {
//            let results = try context.fetch(request)
//           return results.map{
//                Movie(title: $0.title!, posterPath: $0.posterPath!, overview: $0.overview!, rating: $0.rating, genre: $0.genre!)
//            }
//        }
//        catch {
//            print("Error: \(error.localizedDescription)")
//            return []
//        }
//    }
//
//    func deleteMovie(movie:Movie){
//        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "title == %@", movie.title)
//        do{
//            let result = try context.fetch(request)
//            result.forEach{
//                context.delete($0)
//            }
//            print("\(movie.title) is deleted from watchlist")
//            try context.save()
//        }
//        catch{
//            print("Error: \(error.localizedDescription)")
//        }
//    }
//
//
//    func isMovieSaved(title: String) -> Bool {
//        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "title == %@", title)
//        request.fetchLimit = 1
//
//        do {
//            let count = try context.count(for: request)
//            return count > 0
//        } catch {
//            print("Exist check error: \(error)")
//            return false
//        }
//    }
//
//}
