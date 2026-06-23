//
//  HeaderUIView.swift
//  WatchIt
//
//  Created by Survisreevarshith.10852498 on 15/06/26.
//
import UIKit

final class HeaderUIView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let gradientLayer = CAGradientLayer()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()

    private let metaLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(white: 0.86, alpha: 1)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    let addToWatchList: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to Watchlist", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(white: 0, alpha: 0.25)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        return button
    }()

    var onWatchlistTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = imageView.bounds
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        metaLabel.text = "\(movie.genre) • ⭐ \(movie.rating)"

        guard let url = URL(string: movie.posterPath) else {
            imageView.image = UIImage(systemName: "film")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self, let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }

    private func setupUI() {
        backgroundColor = .black

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(metaLabel)
        addSubview(addToWatchList)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: metaLabel.topAnchor, constant: -10),

            metaLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            metaLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            metaLabel.bottomAnchor.constraint(equalTo: addToWatchList.topAnchor, constant: -18),

            addToWatchList.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addToWatchList.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            addToWatchList.heightAnchor.constraint(equalToConstant: 46),
            addToWatchList.widthAnchor.constraint(equalToConstant: 180)
        ])

        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.25).cgColor,
            UIColor.black.withAlphaComponent(0.9).cgColor
        ]
        gradientLayer.locations = [0.0, 0.55, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        imageView.layer.addSublayer(gradientLayer)

        addToWatchList.addTarget(self, action: #selector(watchlistTapped), for: .touchUpInside)
    }

    @objc private func watchlistTapped() {
        onWatchlistTap?()
    }
}
