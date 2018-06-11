//
//  MovieThumbnailCollectionViewCell.swift
//  CineFile
//
//  Created by Zach Vilardell on 6/10/18.
//  Copyright © 2018 zvilardell. All rights reserved.
//

import UIKit
import SDWebImage

class MovieThumbnailCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "MovieThumbnailCollectionViewCell"

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
    func setup(movie: Movie?) {
        posterImageView.sd_setImage(with: movie?.posterImageURL)
        titleLabel.text = movie?.title
        if let releaseDate = movie?.releaseDate {
            yearLabel.text = "(\(TMDBManager.instance.movieDisplayDateFormatter.string(from: releaseDate)))"
        }
    }
}
