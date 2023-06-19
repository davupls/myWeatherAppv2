//
//  ContentView.swift
//  myWeather-v2
//
//  Created by David Mclean on 6/18/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = WeatherAndLocationModel()
    
    var body: some View {
        VStack {
            if let location = model.location {
                VStack {
                    Text("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
                    Text("\(model.currentLocationTemperature)")
                }
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
