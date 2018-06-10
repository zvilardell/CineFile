//
//  Movie.swift
//  CineFile
//
//  Created by Zach Vilardell on 3/1/18.
//  Copyright © 2018 zvilardell. All rights reserved.
//

import Foundation

struct Movie {
    //retrievable from searchMoviesByTitle calls
    var id: UInt?
    var title: String?
    var overview: String?
    var language: String?
    var releaseDate: Date?
    var genres: [Genre]?
    var posterImageURL: URL?
    //retrievable from subsequent getCreditsByMovieID calls using our id
    var directors: [String]?
    var writers: [String]?
    var cinematographers: [String]?
    
    init(movieInfo: [String:Any]) {
        //instantiate Movie object from dictionary
        id = movieInfo["id"] as? UInt
        title = movieInfo["title"] as? String
        overview = movieInfo["overview"] as? String
        language = movieInfo["original_language"] as? String
        if let releaseDateString = movieInfo["release_date"] as? String,
        let releaseDate = TMDBManager.sharedInstance.movieSearchDateFormatter.date(from: releaseDateString) {
            self.releaseDate = releaseDate
        }
        if let genreIDs = movieInfo["genre_ids"] as? [UInt],
        let genres = TMDBManager.sharedInstance.genresFromIDs(genreIDs) {
            self.genres = genres
        }
        if let posterPath = movieInfo["poster_path"] as? String,
        let posterImageURL = TMDBManager.sharedInstance.posterImageURLFromPath(posterPath) {
            self.posterImageURL = posterImageURL
        }
    }
}
