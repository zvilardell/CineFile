//
//  BarcodeScannerViewController.swift
//  CineFile
//
//  Created by Zach Vilardell on 6/13/18.
//  Copyright © 2018 zvilardell. All rights reserved.
//

import UIKit
import MTBBarcodeScanner

class BarcodeScannerViewController: UIViewController {

    var barcodeScanner: MTBBarcodeScanner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barcodeScanner = MTBBarcodeScanner(previewView: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        barcodeScanner?.stopScanning()
        super.viewWillDisappear(animated)
    }

    @IBAction func dismissScanner(_ sender: UIButton?) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        dismissScanner(nil)
    }
}
