//
//  ContentView.swift
//  myWeather-v2
//
//  Created by David Mclean on 6/18/23.
//

import SwiftUI
import WeatherKit

struct ContentView: View {
    @StateObject var model = WeatherAndLocationModel()
    @State var viewBackgroundColor = String()
    @State var fontColor = Color.black
    @State var iconName = String()
    
    //   [✓] Background Color, [✓] Font Color, [✓] Shape, [✓] Icon Color
    
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
                                        Text("\(model.userDeviceLocation)")
                                            .font(.custom("RalewayRoman-Regular", size: 25))
                                        Text("Just updated")
                                            .font(.custom("RalewayRoman-Regular", size: 12))
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.top, 180)
                            }
                            
                            Text("\(model.themedCondition)")
                                .font(.custom("RalewayRoman-Bold", size: 60))
                            Text("\(model.currentTemperature)")
                                .font(.custom("RalewayRoman-Light", size: 90))
                        }
                        .padding([.horizontal, .bottom])
                    }
                    
//                    MARK: Forecasts
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 80) {
                            VStack(alignment: .leading) {
                                HStack {
                                    ForEach(model.forecastWeekDays, id: \.self) { date in
                                        VStack(alignment: .center) {
                                            Text("\(convertDateToDayAbbr(inputDate: date))")
                                                .frame(width: 70, height: 10)
                                                .font(.body)
                                            Text("\(convertDateToMonth_Day(inputDate: date))")
                                                .frame(width: 70, height: 10)
                                                .font(.body)
                                        }
                                        .font(.caption)
                                        
                                    }
                                }
                                HStack {
                                    ForEach(model.weatherForecast, id: \.self) { condition in
                                        VStack(alignment: .center) {
                                            Image("\(checkForecastConditions(weatherCondition: condition))")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 60, height: 60)
                                            Text("\(forecastConditionName(weatherCondition: condition))")
                                                .frame(width: 70, height: 30)
                                                .font(.caption)
                                        }
                                    }
                                    .font(.caption)
                                    
                                }
                            }
                        }
                    }
                }
                .background(Color("\(viewBackgroundColor)"))
                .foregroundColor(fontColor)
                
                
            } else {
                VStack {
                    Image("WeatherImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    HStack {
                        Text("Loading...")
                        ProgressView()
                    }
                }
                .padding()
            }
        }
        .onReceive(model.$isLoaded) { isLoaded in
            if isLoaded {
                colors()
            }
        }
    }
    
    
    
//  MARK: FUNCTIONS
    
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
    
    func convertDateToDayAbbr(inputDate: Date) -> String {
        
        // Create a DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let dayOfWeek = dateFormatter.string(from: inputDate)
        
        return dayOfWeek
    }
                                             
     func convertDateToMonth_Day(inputDate: Date) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "MM-dd"
         var date = dateFormatter.string(from: inputDate)
         
         if date.first == "0"{
             date = String(date.dropFirst())
         }
         
         
         return date
     }
    
    func checkForecastConditions(weatherCondition: WeatherCondition) -> String {
        var weatherIconName = ""
        
        switch weatherCondition.rawValue {
        case "cloudy", "mostlyCloudy", "partlyCloudy", "blowingDust", "foggy", "haze", "smoky":
            weatherIconName = "CloudyIcon"
        case "windy", "breezy":
            weatherIconName = "WindyIcon"
        case "drizzle", "heavyRain", "isolatedThunderstorms", "rain", "sunShowers", "scattered Thunderstorms", "strongStorms", "thunderstorms", "hurricane", "tropicalStorm", "hail":
            weatherIconName = "RainyIcon"
        case "clear", "mostlyClear", "hot":
            weatherIconName = "SunnyIcon"
        default:
            weatherIconName = "SunnyIcon"
        }
        
        return weatherIconName
    }
    
                            
    func forecastConditionName(weatherCondition: WeatherCondition) -> String {
        var weatherConditionName = ""
        
        switch weatherCondition.rawValue {
        case "cloudy", "mostlyCloudy", "partlyCloudy", "blowingDust", "foggy", "haze", "smoky":
            weatherConditionName = "Cloudy"
        case "windy", "breezy":
            weatherConditionName = "Windy"
        case "drizzle", "heavyRain", "isolatedThunderstorms", "rain", "sunShowers", "scattered Thunderstorms", "strongStorms", "thunderstorms", "hurricane", "tropicalStorm", "hail":
            weatherConditionName = "Rainy"
        case "clear", "mostlyClear", "hot":
            weatherConditionName = "Sunny"
        default:
            weatherConditionName = "sunny"
        }
        
        return weatherConditionName
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
