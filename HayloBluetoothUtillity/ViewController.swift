//
//  ViewController.swift
//  HayloBluetoothUtillity
//
//  Created by Chance Daniel on 1/22/17.
//  Copyright © 2017 Haylo. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate {
    
    private var centralManager: CBCentralManager?
    @IBOutlet weak var textView: UITextView!
    
    var discoveredPeripherals: [CBPeripheral] = []

    override func viewDidLoad() {
        super.viewDidLoad()
  
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    // MARK - CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn) {
            print("CBCentralManager Powered On")
            let options: [String: Any] = [CBCentralManagerScanOptionAllowDuplicatesKey : false]
            centralManager?.scanForPeripherals(withServices: nil, options: options)
        }
        else if (central.state == .poweredOff) {
            print("CBCentralManager Powered Off")
        }
        else if (central.state == .resetting) {
            print("CBCentralManager Resetting")
        }
        else if (central.state == .unauthorized) {
            print("CBCentralManager Unauthorized")
        }
        else if (central.state == .unknown) {
            print("CBCentralManager Unknown")
        }
        else if (central.state == .unsupported) {
            print("CBCentralManager Unsupported")
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
            
            var oldText = ""
            if (textView.text != nil) {
                oldText = textView.text!
            }
            oldText += "\n"
            oldText += peripheral.description
            textView.text = oldText

        }
    }

}

