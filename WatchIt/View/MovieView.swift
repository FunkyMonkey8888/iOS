//
//  MovieView.swift
//  WatchIt
//
//  Created by Survisreevarshith.10852498 on 10/06/26.
//
import UIKit

final class MovieView: UIView {

    private let gradientLayer = CAGradientLayer()

    private let metaContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.08)
        view.layer.cornerRadius = 12
        return view
    }()

    private let metaStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()

    let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        imageView.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        return imageView
    }()

    let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()

    let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 3
        label.textColor = UIColor(white: 0.88, alpha: 1.0)
        label.textAlignment = .left
        return label
    }()

    let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("... More", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.contentHorizontalAlignment = .left
        return button
    }()

    let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add To Watchlist", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 229/255, green: 9/255, blue: 20/255, alpha: 1)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        return button
    }()

    private let imageOverlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }()

    private var isExpanded = false
    private var fullOverviewText = ""

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
        gradientLayer.frame = imageOverlayView.bounds
    }

    private func setupUI() {
        backgroundColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)

        addSubview(imageView)
        imageView.addSubview(imageOverlayView)

        addSubview(titleLabel)
        addSubview(metaContainerView)
        metaContainerView.addSubview(metaStackView)

        metaStackView.addArrangedSubview(genreLabel)
        metaStackView.addArrangedSubview(ratingLabel)

        addSubview(overviewLabel)
        addSubview(moreButton)
        addSubview(playButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 220),
            imageView.heightAnchor.constraint(equalToConstant: 320),

            imageOverlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
            imageOverlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            imageOverlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            imageOverlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            metaContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            metaContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),

            metaStackView.topAnchor.constraint(equalTo: metaContainerView.topAnchor, constant: 6),
            metaStackView.leadingAnchor.constraint(equalTo: metaContainerView.leadingAnchor, constant: 10),
            metaStackView.trailingAnchor.constraint(equalTo: metaContainerView.trailingAnchor, constant: -10),
            metaStackView.bottomAnchor.constraint(equalTo: metaContainerView.bottomAnchor, constant: -6),

            overviewLabel.topAnchor.constraint(equalTo: metaContainerView.bottomAnchor, constant: 22),
            overviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            overviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            moreButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 6),
            moreButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            moreButton.heightAnchor.constraint(equalToConstant: 24),

            playButton.topAnchor.constraint(equalTo: moreButton.bottomAnchor, constant: 22),
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            playButton.heightAnchor.constraint(equalToConstant: 48),
            playButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -24)
        ])

        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.18).cgColor,
            UIColor.black.withAlphaComponent(0.85).cgColor
        ]
        gradientLayer.locations = [0.0, 0.58, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        imageOverlayView.layer.insertSublayer(gradientLayer, at: 0)

        moreButton.addTarget(self, action: #selector(toggleOverview), for: .touchUpInside)
    }

    func configure(movie: Movie) {
        titleLabel.text = movie.title
        genreLabel.text = movie.genre
        ratingLabel.text = "⭐ \(movie.rating)"

        fullOverviewText = movie.overview
        overviewLabel.text = fullOverviewText
        overviewLabel.numberOfLines = 3
        isExpanded = false

        if fullOverviewText.count > 120 {
            moreButton.isHidden = false
            moreButton.setTitle("... More", for: .normal)
        } else {
            moreButton.isHidden = true
        }

        guard let url = URL(string: movie.posterPath) else {
            imageView.image = UIImage(systemName: "film")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self, let data else { return }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }.resume()
    }

    @objc private func toggleOverview() {
        isExpanded.toggle()

        if isExpanded {
            overviewLabel.numberOfLines = 0
            moreButton.setTitle("Less", for: .normal)
        } else {
            overviewLabel.numberOfLines = 3
            moreButton.setTitle("... More", for: .normal)
        }

        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}
