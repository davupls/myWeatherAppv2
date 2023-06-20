//
//  ContentView.swift
//  myWeather-v2
//
//  Created by David Mclean on 6/18/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = WeatherAndLocationModel()
    @State var viewBackgroundColor = String()
    @State var fontColor = Color.black
    
    //   [✓] Background Color, [✓] Font Color, Shape, Icon Color
    
    var body: some View {
        VStack {
            if model.isLoaded == true {
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
                                    
                                    Spacer()
                                }
                                .padding(.top, 180)
                            }
                            
                            Text("\(model.themedCondition)")
                                .font(.custom("RalewayRoman-Bold", size: 38))
                            Text("\(model.currentTemperature)")
                                .font(.custom("RalewayRoman-Light", size: 70))
                        }
                        .padding(.horizontal)
                    }
                }
                .background(Color("\(viewBackgroundColor)"))
                .foregroundColor(fontColor)
                
            } else {
                ProgressView()
            }
        }
        .onReceive(model.$isLoaded) { isLoaded in
            if isLoaded {
                colors()
            }
        }
    }
    
    func colors() {
        if model.themedCondition == "Cloudy" {
            viewBackgroundColor = "soft-blue"
            viewBackgroundColor = "soft-yellow"
            
            
        } else if model.themedCondition == "Sunny" {
            viewBackgroundColor = "soft-red"
            fontColor = Color("soft-white")
            
        } else if model.themedCondition == "Windy" {
            viewBackgroundColor = "soft-yellow"
            fontColor = Color(.black)
            
        } else if model.themedCondition == "Rainy" {
            viewBackgroundColor = "soft-white"
            fontColor = Color(.black)
            
        } else {
            viewBackgroundColor = "soft-white"
            print("Error with Weather Condition, check themeCondition variable.")
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
