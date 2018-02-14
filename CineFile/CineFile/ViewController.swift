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
        // Do any additional setup after loading the view, typically from a nib.
        APIRequestManager.sharedInstance.getConfiguration()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

