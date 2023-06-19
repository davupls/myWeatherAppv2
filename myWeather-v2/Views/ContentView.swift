//
//  ContentView.swift
//  myWeather-v2
//
//  Created by David Mclean on 6/18/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = WeatherAndLocationModel()
    @State var backgroundColor = String()
    
    //    Background Color, Font Color, Shape, Icon Color
    
    var body: some View {
        VStack {
            if let location = model.location {
                VStack {
                    GeometryReader { geo in
                        VStack(alignment: .leading) {
                            ZStack {
                                SunnyWeatherShapes()
                                    .frame(width: geo.size.width, height: geo.size.width)
                                    .offset(x: -20, y: -80)
                                HStack {
                                    
                                    Image(systemName: "location")
                                        .padding(.trailing, 2)
                                    
                                    VStack(alignment: .leading) {
                                        Text("\("Chicago")")
                                            .font(.custom("RalewayRoman-Regular", size: 25))
                                        Text("Just updated")
                                            .font(.custom("RalewayRoman-Regular", size: 12))
                                    }
                                    .padding(.top, 180)
                                    
                                    Spacer()
                                }
                            }
                            
                            Text("\(model.themedCondition)")
                                .font(.custom("RalewayRoman-Bold", size: 38))
                            Text("\(model.currentTemperature)")
                                .font(.custom("RalewayRoman-Light", size: 70))
                        }
                        .padding(.horizontal)
                    }
                }
            } else {
                ProgressView()
            }
        }
    }
    
    func colors() {
        if model.themedCondition == "Cloudy" {
            backgroundColor = "soft-blue"
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
