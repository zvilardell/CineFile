//
//  MovieThumbnailCollectionViewCell.swift
//  CineFile
//
//  Created by Zach Vilardell on 6/10/18.
//  Copyright © 2018 zvilardell. All rights reserved.
//

import UIKit

class MovieThumbnailCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "MovieThumbnailCollectionViewCell"

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleYearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
    func setup(movie: Movie?) {
        print(movie)
    }
}
