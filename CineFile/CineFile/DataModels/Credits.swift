//
//  Credits.swift
//  CineFile
//
//  Created by Zach Vilardell on 6/10/18.
//  Copyright © 2018 zvilardell. All rights reserved.
//

import Foundation

struct Credits {
    var directors: [String] = []
    var writers: [String] = []
    var cinematographers: [String] = []
    
    init(movieCreditsInfo: [String:Any]) {
        //instantiate Credits object from dictionary
        guard let crewCredits = movieCreditsInfo["crew"] as? [[String:Any]] else {
            return
        }
        parseCredits(crewCredits)
    }
    
    private mutating func parseCredits(_ credits: [[String:Any]]) {
        //parse credits once rather than filter and map for each role
        for credit in credits {
            if let name = credit["name"] as? String,
            let department = credit["department"] as? String,
            let job = credit["job"] as? String {
                if department == "Directing" && job == "Director" {
                    directors.append(name)
                    continue
                }
                if department == "Writing" && job == "Writer" {
                    writers.append(name)
                    continue
                }
                if department == "Camera" && job == "Director of Photography" {
                    cinematographers.append(name)
                }
            }
        }
    }
}
