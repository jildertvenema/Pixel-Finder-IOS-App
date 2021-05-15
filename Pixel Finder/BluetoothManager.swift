import Foundation
import CoreBluetooth

struct BluetoothStruct {
    var name : String?
    var rssi : NSNumber!
    var advertisementData: [String : Any]!
    var uuid : String!
}

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var allBluetoothArray = [BluetoothStruct]();
    var arrayPeripehral = [CBPeripheral]()
    var cbCentralManager : CBCentralManager?

    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
    
    @Published var lastUpdate: String
    
    
     override init() {
        self.lastUpdate = "now";
        super.init()
        cbCentralManager = CBCentralManager(delegate: self, queue: nil);
        
        allBluetoothArray = [BluetoothStruct]();
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Scanning bluetooth...");
            cbCentralManager?.scanForPeripherals(withServices: nil, options: nil);
        } else{
            print("Bluetooth'un çalışmıyor, lütfen düzelt");
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("found bluetooth1...");
            if let services = peripheral.services {
                for service in services {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }

    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        print("Connected peripheral: \(peripheral.name ?? "UNKNOWN NAME")")
        print(peripheral.discoverServices(nil))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("discovered characteristics")
        if let characteristics = service.characteristics {
              for char in characteristics {
                
                // MESSAGE DEGREES OFFSET TO ESP32
                let messageToSend = "69"
                peripheral.writeValue(messageToSend.data(using: .utf8)!, for: char, type: .withResponse)
              }
          }
      }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        var bluetoothStruct = BluetoothStruct();

        if let name = peripheral.name{
            bluetoothStruct.name = name;
        }

        bluetoothStruct.uuid = peripheral.identifier.uuidString;
        bluetoothStruct.rssi = RSSI;
        bluetoothStruct.advertisementData = advertisementData;

        if !(allBluetoothArray.contains(where: {$0.uuid == peripheral.identifier.uuidString})){
            allBluetoothArray.append(bluetoothStruct);
            arrayPeripehral.append(peripheral)
            // print(allBluetoothArray)
        }
        
        if (peripheral.name == "Pixel Finder") {
            print("FOUND Pixel Finder")
            cbCentralManager?.connect(peripheral,options: nil)
        } else {
            print("DID NOT FOUND Pixel Finder")
        }

    }

}
