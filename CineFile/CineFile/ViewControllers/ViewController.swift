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
        TMDBManager.sharedInstance.searchMoviesByTitle(title: "Days of Heaven") { _ in
            TMDBManager.sharedInstance.getCreditsByMovieID(id: 16642) { _ in }
        }
    }
}

