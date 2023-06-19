//
//  WeatherAndLocationModel.swift
//  myWeather-v2
//
//  Created by David Mclean on 6/19/23.
//

import Foundation
import WeatherKit
import CoreLocation

public class WeatherAndLocationModel: NSObject, ObservableObject, CLLocationManagerDelegate {

//  ********* Location
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
//  ********* Weather
    @Published private(set) var currentTemperature = String()
    @Published private(set) var currentWeatherCondition = String()
    @Published private(set) var forecastWeekDays = Array<Date>()
    @Published private(set) var weatherForecast  = Array<WeatherCondition>()
    @Published private(set) var isLoaded = false
    private let weatherService = WeatherService()
    
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()     // Required to start 
    }

    
    
//    Fetches Device Coordinates
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        locationManager.stopUpdatingLocation()      // Required to stop
        getWeatherData()
    }
//    In Case Device Coordinates fail
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    
//    Get Weather Data from WeatherKit
    func getWeatherData() {
        Task {
            do {
                let weather = try await weatherService.weather(for: location!)
                
                DispatchQueue.main.async {
                    self.currentTemperature         = weather.currentWeather.temperature.formatted()
                    self.currentWeatherCondition    = weather.currentWeather.condition.rawValue
                }
            } catch {
                print("\nRetrieving Weather failed: \n \(error.localizedDescription)\n\n")
            }
        }
    }
    
    
    
    var formatCondition : String {
        get {
            switch currentWeatherCondition {
            case "blowingDust":
//                self.currentWeatherCondition  = "Blowing Dust"
                return "Windy"
            case "clear":
//                self.currentWeatherCondition  = "Clear"
                return "Windy"
            case "cloudy":
//                self.currentWeatherCondition  = "Cloudy"
                return "Windy"
            case "foggy":
//                self.currentWeatherCondition  = "Foggy"
                return "Windy"
            case "haze":
//                self.currentWeatherCondition  = "Hazy"
                return "Windy"
            case "mostlyClear":
//                self.currentWeatherCondition  = "Mostly Clear"
                return "Windy"
            case "mostlyCloudy":
//                self.currentWeatherCondition  = "Mostly Coudy"
                return "Windy"
            case "partlyCloudy":
//                self.currentWeatherCondition  = "Partly Cloudy"
                return "Windy"
            case "smoky":
//                self.currentWeatherCondition  = "Smoky"
                return "Windy"
            case "drizzle":
//                self.currentWeatherCondition  = "Light Rain"
                return "Windy"
            case "heavyRain":
//                self.currentWeatherCondition  = "Heavy Rain"
                return "Windy"
            case "isolatedThunderstorms":
//                self.currentWeatherCondition  = "Thunderstorm"
                return "Windy"
            case "rain":
//                self.currentWeatherCondition  = "Rainy"
                return "Windy"
            case "windy":
//                self.currentWeatherCondition  = "Windy"
                return "Windy"
            default:
//                self.currentWeatherCondition  = "sunny"
                print("\n\nError with Switch Statement: Check Model\n \(currentWeatherCondition)\n")
                return "Windy"
            }
            
        }
    }
    
    
    
}
