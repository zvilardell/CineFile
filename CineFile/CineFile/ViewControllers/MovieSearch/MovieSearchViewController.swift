//
//  MovieSearchViewController.swift
//  CineFile
//
//  Created by Zach Vilardell on 6/10/18.
//  Copyright © 2018 zvilardell. All rights reserved.
//

import UIKit

class MovieSearchViewController: UIViewController {
    
    @IBOutlet weak var movieSearchCollectionView: UICollectionView!
    var movieSearchResults: [Movie]?
    
    let searchResultsSideMarginSpacing: CGFloat = 12.0 //12 points spacing on sides of collection view
    let searchResultsInteritemSpacing: CGFloat = 8.0 //minimum of 8 points spacing between row items in the collectionview
    let searchResultsLineSpacing: CGFloat = 24.0 //minimum of 24 points spacing between rows in the collectionview
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieSearchCollectionView.register(UINib(nibName: "MovieThumbnailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MovieThumbnailCollectionViewCell.reuseIdentifier)
        TMDBManager.instance.searchMoviesByTitle(title: "Days of Heaven") { [unowned self] movies in
            self.movieSearchResults = movies
            self.movieSearchCollectionView.reloadData()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - UICollectionViewDataSource
extension MovieSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieSearchResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieThumbnailCollectionViewCell.reuseIdentifier, for: indexPath) as? MovieThumbnailCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setup(movie: movieSearchResults?[indexPath.item])
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension MovieSearchViewController: UICollectionViewDelegate {
    
}

extension MovieSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //cellWidth is half the width of the collectionview minus half the collectionview's interitem spacing
        let cellWidth = floor(collectionView.bounds.width / 2.0) - floor(searchResultsInteritemSpacing / 2.0)
        return CGSize(width: cellWidth, height: cellWidth * 2.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return searchResultsLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return searchResultsInteritemSpacing
    }
}
