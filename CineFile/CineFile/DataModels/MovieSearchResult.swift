//
//  MovieSearchResult.swift
//  CineFile
//
//  Created by Zach Vilardell on 3/5/18.
//  Copyright © 2018 zvilardell. All rights reserved.
//

import Foundation

struct MovieSearchResult {
    var id: UInt!
    var title: String!
    var overview: String!
    var language: String!
    var releaseDate: Date!
    var genres: [Genre]!
    var posterImageURL: URL!
}
