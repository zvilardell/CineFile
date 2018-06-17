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
    
    weak var presenter: MovieSearchViewController?

    var barcodeScanner: MTBBarcodeScanner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barcodeScanner = MTBBarcodeScanner(previewView: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startScanning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        barcodeScanner?.stopScanning()
        super.viewWillDisappear(animated)
    }
    
    deinit {
        print("DEINIT_\(self)")
    }
    
    private func startScanning() {
        MTBBarcodeScanner.requestCameraPermission { [weak self] permissionGranted in
            if permissionGranted {
                do {
                    try self?.barcodeScanner?.startScanning{ barcodesFound in
                        if let code = barcodesFound?.first, let barcodeString = code.stringValue {
                            self?.barcodeScanner?.freezeCapture()
                            TMDBManager.instance.getMovieTitleFromBarcodeString(barcodeString) { movieTitle in
                                if let title = movieTitle {
                                    self?.presenter?.barcodeScanResultTitleString = title
                                }
                                self?.dismissScanner()
                            }
                            self?.barcodeScanner?.stopScanning()
                        }
                    }
                } catch {
                    NSLog("Unable to scan for barcodes.")
                }
            } else {
                let alertController = UIAlertController(title: "Scanning Unavailable", message: "Please adjust your Cinefile camera permissions to allow barcode scanning", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self?.dismissScanner()
                }
                alertController.addAction(okAction)
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }

    @IBAction func dismissScanner() {
        dismiss(animated: true, completion: nil)
    }
}
