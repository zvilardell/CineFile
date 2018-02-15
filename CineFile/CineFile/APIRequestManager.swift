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
    
    var tmdbKey: String!
    var baseRequestURL = "https://api.themoviedb.org/3"
    var configurationEndpoint = "/configuration"
    var searchEndpoint = "/search/movie"
    
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
            //make initial api call for configuration data
            getConfiguration()
        } else {
            print("Unable to retrieve API key.")
        }
    }
    
    //---------------------------------------------------------------------------------------------------------------------------

    func getConfiguration() {
        //retrieve tmdb configuration data
        let parameterDict: [String:String] = [
            "api_key" : tmdbKey
        ]
        Alamofire.request(baseRequestURL + configurationEndpoint, method: .get, parameters: parameterDict).responseJSON { response in
            if let responseDict = response.result.value as? NSDictionary, let imageConfigDict = responseDict["images"] as? NSDictionary {
                //print(responseDict)
                print(imageConfigDict["secure_base_url"] as! String)
                let sizes = imageConfigDict["poster_sizes"] as! [String]
                let filteredSizes = sizes.filter {string in
                    return string.count == 4 && string >= "w500"
                }
                print(filteredSizes)
            }
        }
    }
    
    func searchMoviesByTitle(title: String) {
        let parameterDict: [String:String] = [
            "api_key" : tmdbKey,
            "query"   : title
        ]
        Alamofire.request(baseRequestURL + searchEndpoint, method: .get, parameters: parameterDict).responseJSON { response in
            if let responseDict = response.result.value as? NSDictionary, let searchResults = responseDict["results"] as? [NSDictionary] {
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
            if let responseDict = response.result.value as? NSDictionary {
                print(responseDict)
            }
        }
    }
}
