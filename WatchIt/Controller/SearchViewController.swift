//
//  SearchViewController.swift
//  WatchIt
//
//  Created by Survisreevarshith.10852498 on 11/06/26.
//

import UIKit

class SearchViewController: UIViewController {

    //    let movies: [Movie] = [
    //        Movie(title: "The Dark Knight", posterPath: "https://upload.wikimedia.org/wikipedia/en/1/1c/The_Dark_Knight_%282008_film%29.jpg", overview: "A movie about a man who fights crime", rating: 9.0, genre: "Action"),
    //        Movie(title: "Inception", posterPath: "https://m.media-amazon.com/images/M/MV5BZjhkNjM0ZTMtNGM5MC00ZTQ3LTk3YmYtZTkzYzdiNWE0ZTA2XkEyXkFqcGc@._V1_.jpg", overview: "A thief enters dreams to steal secrets.", rating: 8.8, genre: "Sci-Fi"),
    //        Movie(title: "Interstellar", posterPath: "https://m.media-amazon.com/images/M/MV5BYzdjMDAxZGItMjI2My00ODA1LTlkNzItOWFjMDU5ZDJlYWY3XkEyXkFqcGc@._V1_.jpg", overview: "Explorers travel through a wormhole in space.", rating: 8.6, genre: "Adventure"),
    //        Movie(title: "Titanic", posterPath: "https://m.media-amazon.com/images/M/MV5BYzYyN2FiZmUtYWYzMy00MzViLWJkZTMtOGY1ZjgzNWMwN2YxXkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg", overview: "A story of love and survival.", rating: 7.9, genre: "Drama"),
    //        Movie(title: "Avengers: Endgame", posterPath: "https://m.media-amazon.com/images/M/MV5BMTc5MDE2ODcwNV5BMl5BanBnXkFtZTgwMzI2NzQ2NzM@._V1_FMjpg_UX1000_.jpg", overview: "The Avengers assemble once more to reverse the damage caused by Thanos.", rating: 8.4, genre: "Superhero"),
    //        Movie(title: "Joker", posterPath: "https://upload.wikimedia.org/wikipedia/en/e/e1/Joker_%282019_film%29_poster.jpg", overview: "A failed comedian begins a descent into madness and becomes Gotham's infamous villain.", rating: 8.4, genre: "Thriller"),
    //        Movie(title: "Parasite", posterPath: "https://m.media-amazon.com/images/M/MV5BYjk1Y2U4MjQtY2ZiNS00OWQyLWI3MmYtZWUwNmRjYWRiNWNhXkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg", overview: "A poor family schemes to become employed by a wealthy household.", rating: 8.5, genre: "Drama"),
    //        Movie(title: "Whiplash", posterPath: "https://m.media-amazon.com/images/M/MV5BMDFjOWFkYzktYzhhMC00NmYyLTkwY2EtYjViMDhmNzg0OGFkXkEyXkFqcGc@._V1_.jpg", overview: "A young drummer is pushed to the limit by a ruthless music instructor.", rating: 8.5, genre: "Drama")
    //    ]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var movies: [Movie] = []
    var filteredMovies: [Movie] = []
    var selectedGenre: String = "All"

    var genres: [String] {
        let allGenres = movies.map {
            $0.genre.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? $0.genre
        }
        let uniqueGenres = Array(Set(allGenres)).sorted()
        return ["All"] + uniqueGenres
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        movies = ParseJson().loadMovies()
        filteredMovies = Array(movies.prefix(10))

        view.backgroundColor = .black
        tableView.backgroundColor = .black
        navigationItem.title = "Search"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
            primaryAction: nil,
            menu: makeFilterMenu()
        )

        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = UIColor(white: 0.12, alpha: 1)
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search a movie",
            attributes: [.foregroundColor: UIColor.lightGray]
        )

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 115
        tableView.separatorStyle = .none
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
    }

    private func navigateToDetail(movie: Movie) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        vc.movie = movie
        navigationController?.pushViewController(vc, animated: true)
    }

    private func makeFilterMenu() -> UIMenu {
        let actions = genres.map { genre in
            UIAction(
                title: genre,
                state: selectedGenre == genre ? .on : .off
            ) { [weak self] _ in
                guard let self = self else { return }
                self.selectedGenre = genre
                self.applyFilters()
                self.navigationItem.rightBarButtonItem?.menu = self.makeFilterMenu()
            }
        }

        return UIMenu(title: "Filter by Genre", children: actions)
    }

    private func applyFilters() {
        let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        filteredMovies = movies.filter { movie in
            let matchesText: Bool
            if text.isEmpty {
                matchesText = true
            } else {
                matchesText =
                    movie.title.localizedCaseInsensitiveContains(text) ||
                    movie.genre.localizedCaseInsensitiveContains(text)
            }

            let primaryGenre = movie.genre
                .components(separatedBy: ",")
                .first?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? movie.genre

            let matchesGenre = selectedGenre == "All" || primaryGenre == selectedGenre

            return matchesText && matchesGenre
        }

        if text.isEmpty && selectedGenre == "All" {
            filteredMovies = Array(filteredMovies.prefix(10))
        }

        tableView.reloadData()
    }
}

extension SearchViewController: UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = filteredMovies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configure(with: movie)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToDetail(movie: filteredMovies[indexPath.row])
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applyFilters()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}














































/*
import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!



    var movies: [Movie] = []
    var filteredMovies: [Movie] = []
    var selectedGenre: String = "All"

    var genres: [String] {
        let allGenres = movies.map {
            $0.genre.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? $0.genre
        }
        let uniqueGenres = Array(Set(allGenres)).sorted()
        return ["All"] + uniqueGenres
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        movies = ParseJson().loadMovies()
        filteredMovies = Array(movies.prefix(10))

        view.backgroundColor = .black
        tableView.backgroundColor = .black
        navigationItem.title = "Search"


        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Filter",
            image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
            primaryAction: nil,
            menu: makeFilterMenu(),

        )


        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = UIColor(white: 0.12, alpha: 1)
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search a movie",
            attributes: [.foregroundColor: UIColor.lightGray]
        )

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 115
        tableView.separatorStyle = .none
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
    }

    private func navigateToDetail(movie: Movie) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        vc.movie = movie
        navigationController?.pushViewController(vc, animated: true)
    }

    private func makeFilterMenu() -> UIMenu {
        let actions = genres.map { genre in
            UIAction(
                title: genre,
                state: selectedGenre == genre ? .on : .off
            ) { [weak self] _ in
                guard let self = self else { return }
                self.selectedGenre = genre
                self.applyFilters()

            }
        }

        return UIMenu(title: "Filter by Genre", children: actions)
    }

    private func applyFilters() {
//        filteredMovies = movies.filter(\.1.isMultiple(of: 2))
        let text = searchBar.text?.lowercased() ?? searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        filteredMovies = movies.filter {
            movie in
            let matchesGenre:Bool
            if text.isEmpty {
                matchesGenre = true
            }
            else{
                matchesGenre = movie.title.localizedStandardContains(text)  || movie.genre.localizedStandardContains(text)

            }
            let primaryGenre = movie.genre.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? movie.genre
            let matchesText = primaryGenre == "All" || primaryGenre.localizedStandardContains(selectedGenre ?? "")
            return matchesGenre && matchesText
        }

        if text.isEmpty && selectedGenre == "All" {
            filteredMovies = Array(filteredMovies.prefix(10))
        }

        tableView.reloadData()


    }
}

extension SearchViewController: UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        filteredMovies.countr
        return filteredMovies.count
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = filteredMovies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configure(with: movie)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToDetail(movie: filteredMovies[indexPath.row])
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applyFilters()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

*/
