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
    let searchResultsInteritemSpacing: CGFloat = 8.0 //minimum of 8 points spacing between row items in the collection view
    let searchResultsLineSpacing: CGFloat = 15.0 //minimum of 24 points spacing between rows in the collection view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieSearchCollectionView.register(UINib(nibName: "MovieThumbnailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MovieThumbnailCollectionViewCell.reuseIdentifier)
        TMDBManager.instance.searchMoviesByTitle(title: "Superbad") { [unowned self] movies in
            var results: [Movie] = []
            for _ in 0...100 {
                results.append(contentsOf: movies!)
            }
            self.movieSearchResults = results
            self.movieSearchCollectionView.reloadData()
        }
    }
    
    @IBAction func scanbarCode(_ sender: UIBarButtonItem) {
        present(BarcodeScanViewController(), animated: true, completion: nil)
    }
}

//MARK: - UICollectionViewDataSource
extension MovieSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieSearchResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieThumbnailCollectionViewCell.reuseIdentifier, for: indexPath) as? MovieThumbnailCollectionViewCell,
        let movie = movieSearchResults?[indexPath.item] else {
            return UICollectionViewCell()
        }
        cell.setup(movie: movie)
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension MovieSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = movieSearchResults?[indexPath.item].id {
            TMDBManager.instance.getCreditsByMovieID(id: id) { credits in
                self.movieSearchResults![indexPath.item].credits = credits
                let c = self.movieSearchResults![indexPath.item].credits!
                print(self.movieSearchResults![indexPath.item])
                print(c.directors)
                print(c.writers)
                print(c.cinematographers)
            }
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MovieSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //cellWidth is half the width of the collectionview minus 150% of the collectionview's interitem spacing value
        let cellWidth = floor(collectionView.bounds.width / 2.0) - floor(searchResultsInteritemSpacing * 1.5)
        return CGSize(width: cellWidth, height: cellWidth * 1.7) //cell is 70% taller than it is wide
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, searchResultsInteritemSpacing, searchResultsInteritemSpacing, searchResultsInteritemSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return searchResultsLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return searchResultsInteritemSpacing
    }
}
