//
//  ContentView.swift
//  Pixel Finder
//
//  Created by Jildert Venema on 15/05/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @StateObject var bluetoothManager = BluetoothManager()
    
    var count = 0;
    
    var userLatitude: String {
         return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
     }
     
     var userLongitude: String {
         return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
     }
    
    var body: some View {
        VStack {
             Text("location status: \(locationManager.statusString)")
             HStack {
                 Text("latitude: \(userLatitude)")
                 Text("longitude: \(userLongitude)")
             }
         }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
