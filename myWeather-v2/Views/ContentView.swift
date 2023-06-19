//
//  ContentView.swift
//  myWeather-v2
//
//  Created by David Mclean on 6/18/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var locationManager = DeviceLocationModel()
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                Text("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
            } else {
                Text("Updating location...")
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
