//
//  MovieTableViewCell.swift
//  WatchIt
//
//  Created by Survisreevarshith.10852498 on 15/06/26.
//

import UIKit

 class MovieTableViewCell: UITableViewCell {

     static let identifier = "MovieTableViewCell"

    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.08, alpha: 1)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = UIColor(white: 0.15, alpha: 1)
        imageView.image = UIImage(systemName: "film")
        imageView.tintColor = .lightGray
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()

    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(white: 0.75, alpha: 1)
        label.numberOfLines = 1
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 1.0, green: 0.83, blue: 0.24, alpha: 1)
        label.numberOfLines = 1
        return label
    }()

    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = UIColor(white: 0.55, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var imageTask: URLSessionDataTask?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        posterImageView.image = UIImage(systemName: "film")
        titleLabel.text = nil
        genreLabel.text = nil
        ratingLabel.text = nil
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        genreLabel.text = movie.genre
        ratingLabel.text = "⭐ \(movie.rating)"

        guard let url = URL(string: movie.posterPath) else {
            posterImageView.image = UIImage(systemName: "film")
            return
        }

        imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self else { return }
            DispatchQueue.main.async {
                if let data, let image = UIImage(data: data) {
                    self.posterImageView.image = image
                } else {
                    self.posterImageView.image = UIImage(systemName: "film")
                }
            }
        }
        imageTask?.resume()
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .black
        selectionStyle = .none

        contentView.addSubview(cardView)
        cardView.addSubview(posterImageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(genreLabel)
        cardView.addSubview(ratingLabel)
        cardView.addSubview(chevronImageView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            posterImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            posterImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 60),
            posterImageView.heightAnchor.constraint(equalToConstant: 80),

            chevronImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 18),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),

            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            genreLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 14),
            genreLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),

            ratingLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 6),
            ratingLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 14),
            ratingLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),
            ratingLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -14)
        ])
    }
}

