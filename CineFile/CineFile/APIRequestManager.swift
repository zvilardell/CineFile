//
//  APIRequestManager.swift
//  CineFile
//
//  Created by Zach Vilardell on 2/13/18.
//  Copyright © 2018 zvilardell. All rights reserved.
//

import UIKit
import Alamofire

class APIRequestManager: NSObject {
    
    //request constants
    var tmdbKey: String!
    let baseRequestURL = "https://api.themoviedb.org/3"
    let configurationEndpoint = "/configuration"
    let searchEndpoint = "/search/movie"
    let movieEndpoint = "/movie"
    
    //set when we retrieve configuration data
    var configuration: TMDBConfiguration!
    
    typealias ConfigurationCompletion = (TMDBConfiguration?)->()
    typealias MoviesByTitleCompletion = ([Movie]?)->()
    typealias MovieByIDCompletion = (Movie?)->()
    
    //---------------------------------------------------------------------------------------------------------------------------
    //singleton setup
    
    static let sharedInstance = APIRequestManager()
    private override init() {
        super.init()
        //grab tmdb api key used to authenticate requests
        if let plistPath = Bundle.main.path(forResource: "Info", ofType: "plist"),
        let plistDict = NSDictionary(contentsOfFile: plistPath),
        let tmdbKey = plistDict["TMDb API Key"] as? String {
            self.tmdbKey = tmdbKey
        } else {
            print("Unable to retrieve API key.")
        }
    }
    
    //---------------------------------------------------------------------------------------------------------------------------

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
                if let responseDict = response.result.value as? [String:Any], let imageConfigDict = responseDict["images"] as? [String:Any],
                let imageURLString = imageConfigDict["secure_base_url"] as? String, let posterSizes = imageConfigDict["poster_sizes"] as? [String] {
                    self.configuration = TMDBConfiguration(baseImageURL: imageURLString, posterImageSize: posterSizes.last ?? "w780") //use the largest image size if possible
                    completion(self.configuration)
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
    
    func searchMoviesByTitle(title: String, completion: @escaping MoviesByTitleCompletion) {
        getConfiguration() {[unowned self] config in
            if let _ = config { //ensure that we've successfully retrieved configuration data before searching movies
                let parameterDict: [String:String] = [
                    "api_key" : self.tmdbKey,
                    "query"   : title
                ]
                Alamofire.request(self.baseRequestURL + self.searchEndpoint, method: .get, parameters: parameterDict).responseJSON { response in
                    if let responseDict = response.result.value as? [String:Any], let searchResults = responseDict["results"] as? [[String:Any]] {
                        print(searchResults)
                        completion(nil)
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
    
    func getMovieByID(id: UInt, completion: @escaping MovieByIDCompletion) {
        let parameterDict: [String:String] = [
            "api_key"  : tmdbKey
        ]
        Alamofire.request(baseRequestURL + movieEndpoint + "/\(id)", method: .get, parameters: parameterDict).responseJSON { response in
            if let responseDict = response.result.value as? [String:Any] {
                print(responseDict)
                completion(nil)
            } else if let error = response.result.error {
                //an error occurred
                print(error.localizedDescription)
                completion(nil)
            } else {
                //an unknown error occurred
                print("Unable to retrieve movie by ID at this time.")
                completion(nil)
            }
        }
    }
}
