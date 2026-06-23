//
//  MovieListViewController.swift
//  WatchIt
//
//  Created by Survisreevarshith.10852498 on 10/06/26.
//

import UIKit

final class MovieListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var movies: [Movie] = []
    private var sections: [MovieSection] = []
    private let headerView = HeaderUIView()
    private var featuredMovie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()

        movies = ParseJson().loadMovies()
        featuredMovie = movies.randomElement()
        buildSections()

        configureUI()
        configureNavigationBar()
        configureTableView()
        configureHeaderView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let headerSize = CGSize(width: view.bounds.width, height: 430)
        if headerView.frame.size != headerSize {
            headerView.frame = CGRect(origin: .zero, size: headerSize)
            tableView.tableHeaderView = headerView
        }
    }

    private func configureUI() {
        view.backgroundColor = .black
        tableView.backgroundColor = .black
    }

    private func configureNavigationBar() {
        navigationItem.title = "Movies"

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

    private func configureTableView() {
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        
    }

    private func configureHeaderView() {
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 430)
        tableView.tableHeaderView = headerView

        if let movie = featuredMovie {
            headerView.configure(with: movie)
        }

        headerView.onWatchlistTap = { [weak self] in
            guard let self, let movie = self.featuredMovie else { return }
            self.navigateToDetail(movie: movie)
        }
    }

    private func buildSections() {
        let grouped = Dictionary(grouping: movies) { movie in
            movie.genre.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Other"
        }

        var result: [MovieSection] = []

        if let action = grouped["Action"], !action.isEmpty {
            result.append(MovieSection(title: "Action", movies: action))
        }

        if let drama = grouped["Drama"], !drama.isEmpty {
            result.append(MovieSection(title: "Drama", movies: drama))
        }

        if let comedy = grouped["Comedy"], !comedy.isEmpty {
            result.append(MovieSection(title: "Comedy", movies: comedy))
        }

        for (genre, list) in grouped where !["Action", "Drama", "Comedy"].contains(genre) && !list.isEmpty {
            result.append(MovieSection(title: genre, movies: list))
        }

        sections = result
    }

    private func navigateToDetail(movie: Movie) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        vc.movie = movie
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate, CollectionViewTableViewCellDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        42
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let container = UIView()
        container.backgroundColor = .black

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = sections[section].title
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .bold)

        container.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -6),
            label.topAnchor.constraint(equalTo: container.topAnchor)
        ])

        return container
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as! CollectionViewTableViewCell
        cell.configure(with: sections[indexPath.section].movies)
        cell.delegate = self
        return cell
    }

    func didSelectMovie(_ movie: Movie) {
        navigateToDetail(movie: movie)
    }
}

















































//import UIKit
//
//class MovieListViewController: UIViewController {
//
//    @IBOutlet weak var collectionView: UICollectionView!
//
//    var movies: [Movie] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        movies = ParseJson().loadMovies()
//
//        configureUI()
//        configureCollectionView()
//        configureNavigationBar()
//    }
//
//    private func configureUI() {
//        view.backgroundColor = .black
//        collectionView.backgroundColor = .black
//        navigationItem.title = "Home"
//    }
//
//    private func configureCollectionView() {
//        collectionView.register(
//            UINib(nibName: "MovieCollectionViewCell", bundle: nil),
//            forCellWithReuseIdentifier: MovieCollectionViewCell.identifier
//        )
//
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.alwaysBounceVertical = true
//        collectionView.showsVerticalScrollIndicator = false
//
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 22
//        layout.minimumInteritemSpacing = 12
//        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 24, right: 16)
//        collectionView.collectionViewLayout = layout
//    }
//
//    private func configureNavigationBar() {
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .black
//        appearance.shadowColor = .clear
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
//        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.isTranslucent = false
//
//        navigationItem.largeTitleDisplayMode = .never
//    }
//
//    private func navigateToDetail(movie: Movie) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
//        vc.movie = movie
//        navigationController?.pushViewController(vc, animated: true)
//    }
//}
//
//extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        movies.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let movie = movies[indexPath.item]
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
//        cell.configure(with: movie)
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedMovie = movies[indexPath.item]
//        navigateToDetail(movie: selectedMovie)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let padding: CGFloat = 16 + 16 + 12
//        let availableWidth = collectionView.bounds.width - padding
//        let width = availableWidth / 2
//        return CGSize(width: width, height: 250)
//    }
//}
