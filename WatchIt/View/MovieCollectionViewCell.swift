//
//  MovieCollectionViewCell.swift
//  WatchIt
//
//  Created by Survisreevarshith.10852498 on 11/06/26.
//
import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    static let identifier = "MovieCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12

        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.numberOfLines = 3
        titleLabel.textAlignment = .left
        titleLabel.contentMode = .scaleToFill
        titleLabel.backgroundColor = .clear
        titleLabel.lineBreakStrategy = .pushOut
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title

        guard let url = URL(string: movie.posterPath) else {
            imageView.image = UIImage(systemName: "film")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(systemName: "film")
                }
            }
        }.resume()
    }

    static func nib() -> UINib {
        UINib(nibName: "MovieCollectionViewCell", bundle: nil)
    }
}
