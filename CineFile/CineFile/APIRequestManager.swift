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
    
    //set when we retrieve configuration data
    var configuration: TMDBConfiguration!
    
    typealias ConfigurationCompletion = (TMDBConfiguration)->()
    
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

    func getConfiguration(completion: @escaping ConfigurationCompletion) {
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
                    self.configuration = TMDBConfiguration(baseImageURL: imageURLString, posterImageSize: posterSizes.last ?? "w500") //use the largest image size if possible
                    completion(self.configuration)
                }
            }
        }
    }
    
    func searchMoviesByTitle(title: String) {
        let parameterDict: [String:String] = [
            "api_key" : tmdbKey,
            "query"   : title
        ]
        Alamofire.request(baseRequestURL + searchEndpoint, method: .get, parameters: parameterDict).responseJSON { response in
            if let responseDict = response.result.value as? [String:Any], let searchResults = responseDict["results"] as? [[String:Any]] {
                print(searchResults[0])
            }
        }
    }
    
    func getMovieByID(id: UInt) {
        let parameterDict: [String:String] = [
            "api_key"  : tmdbKey
        ]
        let movieEndpoint = "/movie/\(id)"
        Alamofire.request(baseRequestURL + movieEndpoint, method: .get, parameters: parameterDict).responseJSON { response in
            if let responseDict = response.result.value as? [String:Any] {
                print(responseDict)
            }
        }
    }
}
