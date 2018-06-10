//
//  TMDBManager.swift
//  CineFile
//
//  Created by Zach Vilardell on 2/13/18.
//  Copyright © 2018 zvilardell. All rights reserved.
//

import UIKit
import Alamofire

class TMDBManager: NSObject {
    
    //request constants
    private var tmdbKey: String!
    private let baseRequestURL = "https://api.themoviedb.org/3"
    private let configurationEndpoint = "/configuration"
    private let genreListEndpoint = "/genre/movie/list"
    private let searchEndpoint = "/search/movie"
    private let creditsEndpoint = "/movie/#/credits" // # replaced by movie id on request
    
    //set when we retrieve configuration data
    private var configuration: TMDBConfiguration!
    
    //completion aliases
    typealias ConfigurationCompletion = (TMDBConfiguration?)->()
    typealias GenreListCompletion = ([UInt:Genre]?)->()
    typealias MoviesByTitleCompletion = ([Movie]?)->()
    typealias CreditsByIDCompletion = (Movie?)->()
    
    var movieSearchDateFormatter = DateFormatter()
    var movieDisplayDateFormatter = DateFormatter()
    
    //---------------------------------------------------------------------------------------------------------------------------
    //singleton setup
    
    static let instance = TMDBManager()
    private override init() {
        super.init()
        movieSearchDateFormatter.dateFormat = "yyyy-MM-dd"
        movieDisplayDateFormatter.dateFormat = "yyyy"
        //grab tmdb api key used to authenticate requests
        if let plistPath = Bundle.main.path(forResource: "Info", ofType: "plist"),
        let plistDict = NSDictionary(contentsOfFile: plistPath),
        let tmdbKey = plistDict["TMDb Key"] as? String {
            self.tmdbKey = tmdbKey
        } else {
            print("Unable to retrieve TMDb key.")
        }
    }
    
    //---------------------------------------------------------------------------------------------------------------------------
}

//MARK: - Configuration Methods
extension TMDBManager {
    private func getConfiguration(completion: @escaping ConfigurationCompletion) {
        if let config = configuration {
            //configuration data already retrieved, just return it
            completion(config)
        } else {
            //retrieve tmdb configuration data
            let parameterDict: [String:String] = [
                "api_key" : tmdbKey
            ]
            Alamofire.request(baseRequestURL + configurationEndpoint, method: .get, parameters: parameterDict).responseJSON {[unowned self] response in
                if let responseDict = response.result.value as? [String:Any],
                let imageConfigDict = responseDict["images"] as? [String:Any],
                let imageURLString = imageConfigDict["secure_base_url"] as? String,
                let posterSizes = imageConfigDict["poster_sizes"] as? [String] {
                    //get tmdb genre list
                    self.getGenreList() { genreDict in
                        if let genres = genreDict {
                            self.configuration = TMDBConfiguration(baseImageURL: imageURLString,
                                                                   posterImageSize: posterSizes.last ?? "w780", //use the highest-quality image size possible
                                                                   genresByID: genres)
                            completion(self.configuration)
                        } else {
                            //unable to retrieve genre data
                            completion(nil)
                        }
                    }
                } else if let error = response.result.error {
                    //an error occurred
                    print(error.localizedDescription)
                    completion(nil)
                } else {
                    //an unknown error occurred
                    print("Unable to retrieve TMDB configuration at this time.")
                    completion(nil)
                }
            }
        }
    }
    
    private func getGenreList(completion: @escaping GenreListCompletion) {
        //retrieve tmdb genre data
        let parameterDict: [String:String] = [
            "api_key" : tmdbKey
        ]
        Alamofire.request(baseRequestURL + genreListEndpoint, method: .get, parameters: parameterDict).responseJSON { response in
            if let responseDict = response.result.value as? [String:Any],
            let genreList = responseDict["genres"] as? [[String:Any]] {
                //build genre dictionary from response
                var genreDict: [UInt:Genre] = [:]
                for genre in genreList {
                    if let id = genre["id"] as? UInt,
                    let name = genre["name"] as? String {
                        genreDict[id] = Genre(rawValue: name)
                    }
                }
                completion(genreDict)
            } else if let error = response.result.error {
                //an error occurred
                print(error.localizedDescription)
                completion(nil)
            } else {
                //an unknown error occurred
                print("Unable to retrieve TMDB genre data at this time.")
                completion(nil)
            }
        }
    }
}

//MARK: - Movie Search Methods
extension TMDBManager {
    func searchMoviesByTitle(title: String, completion: @escaping MoviesByTitleCompletion) {
        getConfiguration() {[unowned self] config in
            if let _ = config { //ensure that we've successfully retrieved configuration data before searching movies
                let parameterDict: [String:String] = [
                    "api_key" : self.tmdbKey,
                    "query"   : title
                ]
                Alamofire.request(self.baseRequestURL + self.searchEndpoint, method: .get, parameters: parameterDict).responseJSON { response in
                    if let responseDict = response.result.value as? [String:Any],
                    let searchResults = responseDict["results"] as? [[String:Any]] {
                        var movieResults: [Movie] = []
                        for result in searchResults {
                            movieResults.append(Movie(movieInfo: result))
                        }
                        completion(movieResults)
                    } else if let error = response.result.error {
                        //an error occurred
                        print(error.localizedDescription)
                        completion(nil)
                    } else {
                        //an unknown error occurred
                        print("Unable to search movies by title at this time.")
                        completion(nil)
                    }
                }
            } else {
                //unable to retrieve configuration data
                completion(nil)
            }
        }
    }
    
    func getCreditsByMovieID(id: UInt, completion: @escaping CreditsByIDCompletion) {
        let parameterDict: [String:String] = [
            "api_key"  : tmdbKey
        ]
        let creditsEndpointComponents: [String] = self.creditsEndpoint.components(separatedBy: "#")
        let creditsEndpoint = creditsEndpointComponents[0] + "\(id)" + creditsEndpointComponents[1]
        Alamofire.request(baseRequestURL + creditsEndpoint, method: .get, parameters: parameterDict).responseJSON { response in
            if let responseDict = response.result.value as? [String:Any] {
                //filter directors, writers, and DPs from response
                print(responseDict)
                completion(nil)
            } else if let error = response.result.error {
                //an error occurred
                print(error.localizedDescription)
                completion(nil)
            } else {
                //an unknown error occurred
                print("Unable to retrieve movie credits at this time.")
                completion(nil)
            }
        }
    }
}

//MARK: - Utility Methods
extension TMDBManager {
    func posterImageURLFromPath(_ path: String) -> URL? {
        guard let config = configuration else {
            print("No TMDb configuration found.")
            return nil
        }
        let urlString = config.baseImageURL + config.posterImageSize + path
        return URL(string: urlString)
    }
    
    func genresFromIDs(_ ids: [UInt]) -> [Genre]? {
        guard let config = configuration else {
            print("No TMDb configuration found.")
            return nil
        }
        var genres: [Genre] = []
        for id in ids {
            if let genre = config.genresByID[id] {
                genres.append(genre)
            }
        }
        return genres
    }
}
