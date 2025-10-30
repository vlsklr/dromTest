//
//  PictureCollectionViewCell.swift
//  DromTest
//
//  Created by v.sklyarov on 29.10.2025.
//

import UIKit

final class PictureCollectionViewCell: UICollectionViewCell {
    
    static let reusableId = "PictureCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.center = contentView.center
        
        return activityIndicator
    }()
    
    var presenter: PictureCollectionViewCellPresenter? {
        didSet {
            imageView.image = presenter?.image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Public methods

extension PictureCollectionViewCell {
    
    func updateImage(_ newImage: UIImage) {
        imageView.image = newImage
        activityIndicator.stopAnimating()
    }
    
    func checkAndToggleIndicator() {
        if presenter?.image == nil {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
}

// MARK: - Private methods

private extension PictureCollectionViewCell {
    
    func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)
        contentView.backgroundColor = .systemGray2
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
}
