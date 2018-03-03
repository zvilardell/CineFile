//
//  TMDBConfiguration.swift
//  CineFile
//
//  Created by Zach Vilardell on 3/1/18.
//  Copyright © 2018 zvilardell. All rights reserved.
//

import Foundation

struct TMDBConfiguration {
    var baseImageURL: String!
    var posterImageSize: String!
    var genresByID: [UInt:Genre]!
    init(baseImageURL: String, posterImageSize: String, genresByID: [UInt:Genre]) {
        self.baseImageURL = baseImageURL
        self.posterImageSize = posterImageSize
        self.genresByID = genresByID
    }
}
