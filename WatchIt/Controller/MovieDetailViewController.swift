//
//  MovieDetailViewController.swift
//  WatchIt
//
//  Created by Survisreevarshith.10852498 on 10/06/26.
//
import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieView: MovieView!

    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        guard let movie = movie else { return }

        movieView.configure(movie: movie)
        updateWatchlistButton()

        movieView.playButton.addTarget(self, action: #selector(watchlistButtonTapped), for: .touchUpInside)
        navigationItem.title = movie.title

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.largeTitleDisplayMode = .never
    }

    private func updateWatchlistButton() {
        guard let movie = movie else { return }

        let isSaved = DataManager.shared.isMovieSaved(title: movie.title)

        if isSaved {
            movieView.playButton.setTitle("Remove From Watchlist", for: .normal)
            movieView.playButton.backgroundColor = .darkGray
        } else {
            movieView.playButton.setTitle("Add To Watchlist", for: .normal)
            movieView.playButton.backgroundColor = UIColor(red: 229/255, green: 9/255, blue: 20/255, alpha: 1)
        }
    }

    @objc private func watchlistButtonTapped() {
        guard let movie = movie else { return }

        let isSaved = DataManager.shared.isMovieSaved(title: movie.title)

        if isSaved {
            DataManager.shared.deleteMovie(movie: movie)
        } else {
            DataManager.shared.saveMovie(movie)
        }

        updateWatchlistButton()
    }
}





