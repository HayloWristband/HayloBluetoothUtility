//
//  ViewController.swift
//  HayloBluetoothUtillity
//
//  Created by Chance Daniel on 1/22/17.
//  Copyright © 2017 Haylo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    private var bluetoothManager: HAYBluetoothManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBluetoothManager()
  
    }
    
    func setUpBluetoothManager() {
        bluetoothManager = HAYBluetoothManager()
        
    }
}

