//
//  HAYBluetoothManager.swift
//  HayloBluetoothUtillity
//
//  Created by Ridge Nelson on 2/14/17.
//  Copyright © 2017 Haylo. All rights reserved.
//

import UIKit
import CoreBluetooth

class HAYBluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    private var centralManager: CBCentralManager!
    private var wristbandPeripheral: CBPeripheral?
    
    private var writeCharacteristic: CBCharacteristic?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    func writeMessageToCharacteristic(message: String, characteric: CBCharacteristic) {
        guard let wristbandPeripheral = wristbandPeripheral else {return}
        while (true) {
            wristbandPeripheral.writeValue((message.data(using: .utf8))!, for: characteric, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    // MARK: - CBCentralManagerDelagate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn) {
            print("CBCentralManager Powered On")
            let options: [String: Any] = [CBCentralManagerScanOptionAllowDuplicatesKey : false]
            centralManager?.scanForPeripherals(withServices: [CBUUID(string: HAYBluetoothServiceUUID)], options: options)
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
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Did Find: \(peripheral.name)")

        wristbandPeripheral = peripheral
        if let wristbandPeripheral = wristbandPeripheral {
            centralManager?.connect(wristbandPeripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        central.stopScan()
    }
    
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Did fail to connect: \(error?.localizedDescription)")
    }

    // MARK: - CBPeripheralDelagate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Services: \(peripheral.services)")
        
        if ((error) != nil) {
            print(error!.localizedDescription)
            return
        }
        
        if let services = peripheral.services {
            if let service = services.first {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if ((error) != nil) {
            print(error!.localizedDescription)
            return
        }
        
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == CBUUID(string: HAYBluetoothWriteCharacteristicUUID) {
//                    let writeString = "Test"
//                    peripheral.writeValue((writeString.data(using: .utf8))!, for: characteristic, type: CBCharacteristicWriteType.withResponse)
                    writeCharacteristic = characteristic
                }
                else if characteristic.uuid == CBUUID(string: HAYBluetoothReadCharacteristicUUID) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
        
        
//        print("Service Characteristics: \(service.characteristics)")

        
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if ((error) != nil) {
            print(error!.localizedDescription)
            return
        }
        print("Did Update Notification State For Characteristic: \(characteristic)")
        
        if let writeCharacteristic = writeCharacteristic {
            writeMessageToCharacteristic(message: "F THIS", characteric: writeCharacteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Did Update Value For Characteristic: \(characteristic)")
        if let data = characteristic.value {
            print(String(data: data, encoding: .utf8))
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if ((error) != nil) {
            print(error!.localizedDescription)
            return
        }
        print("Did Write To Characteristic: \(characteristic)")
    }
    
}
