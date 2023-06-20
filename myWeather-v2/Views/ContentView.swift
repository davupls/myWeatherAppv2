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
    @State var iconName = String()
    
    //   [✓] Background Color, [✓] Font Color, [✓] Shape, Icon Color
    
    var body: some View {
        VStack {
            if model.isLoaded == true {
                VStack {
                    GeometryReader { geo in
                        VStack(alignment: .leading) {
                            ZStack {
                                WeatherShapeView()
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
                            Image("\(iconName)")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(fontColor)
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
            iconName = "CloudyIcon"
            
            
        } else if model.themedCondition == "Sunny" {
            viewBackgroundColor = "soft-red"
            fontColor = Color("soft-white")
            iconName = "SunnyIcon"
            
        } else if model.themedCondition == "Windy" {
            viewBackgroundColor = "soft-yellow"
            fontColor = Color(.black)
            iconName = "WindyIcon"
            
        } else if model.themedCondition == "Rainy" {
            viewBackgroundColor = "soft-white"
            fontColor = Color(.black)
            iconName = "RainyIcon"
            
        } else {
            viewBackgroundColor = "soft-white"
            iconName = "CloudyIcon"
            print("Error with Weather Condition, check themeCondition variable.")
            
        }
    }
    
    func WeatherShapeView() -> some View {
        /*  This needs to be in a group to let
         SwiftUI know these Views are of the same type.
         */
        
        Group {
            if model.themedCondition == "Sunny" {
                SunnyWeatherShapes()
            } else if model.themedCondition == "Cloudy"{
                CloudyWeatherShapes()
            } else if model.themedCondition == "Windy"{
                CloudyWeatherShapes()
            } else if model.themedCondition == "Rainy"{
                RainyWeatherShapes()
            } else {
                WindyWeatherShapes()
            }
        }
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
