//
//  Movie.swift
//  CineFile
//
//  Created by Zach Vilardell on 3/1/18.
//  Copyright © 2018 zvilardell. All rights reserved.
//

import Foundation

struct Movie {
    var id: UInt!
    var title: String!
    var overview: String!
    var language: String!
    var releaseDate: Date!
    var genres: [Genre]!
    var directors: [String]!
    var writers: [String]!
    var cinematographers: [String]!
    var posterImageURL: URL!
}
