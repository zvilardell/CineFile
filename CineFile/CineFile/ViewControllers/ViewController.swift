//
//  ViewController.swift
//  CineFile
//
//  Created by Zach Vilardell on 2/9/18.
//  Copyright © 2018 zvilardell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        TMDBManager.instance.searchMoviesByTitle(title: "Days of Heaven") { movies in
            TMDBManager.instance.getCreditsByMovieID(id: movies![0].id!) { _ in }
        }
    }
}

