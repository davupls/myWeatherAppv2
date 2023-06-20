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
    @Published private(set) var forecastWeekDays    = Array<Date>()
    @Published private(set) var weatherForecast     = Array<WeatherCondition>()
    @Published private(set) var themedCondition     = String()
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
                
                DispatchQueue.main.async { [self] in
                    self.currentTemperature         = weather.currentWeather.temperature.formatted()
                    self.currentWeatherCondition    = weather.currentWeather.condition.rawValue
                    
//                   MARK: Forecast Data
                    let forecast: Forecast<DayWeather> = weather.dailyForecast
                    self.forecastWeekDays       = Array(forecast.map { $0.date })
                    self.weatherForecast        = Array(forecast.map { $0.condition })
                    
                    switch currentWeatherCondition {
                        
                    case "clear", "mostlyClear", "hot":
                        themedCondition = "Sunny"
                        isLoaded = true
                        
                    case "cloudy", "mostlyCloudy", "partlyCloudy", "blowingDust", "foggy", "haze", "smoky":
                        themedCondition = "Cloudy"
                        isLoaded = true
                        
                    case "Windy", "Breezy":
                        themedCondition = "Windy"
                        isLoaded = true
                        
                    case "Drizzle", "HeavyRain", "Thunderstorm", "Rain", "SunShowers", "Scattered Thunderstorms", "strongStorms", "thunderstorms", "hurricane", "tropicalStorm", "hail":
                        themedCondition = "Rainy"
                        isLoaded = true
                    
                    default:
                        print("\n\nError with Switch Statement: Check Model\n \(currentWeatherCondition)\n")
                        themedCondition = "sunny"
                        isLoaded = true
                    }
                }
            } catch {
                print("\nRetrieving Weather failed: \n \(error.localizedDescription)\n\n")
            }
        }
        
        
    }
    
    
    
    var formatCondition : String {
        get {
            switch currentWeatherCondition {
                
            case "clear", "mostlyClear", "hot":
                return "Sunny"
                
            case "cloudy", "mostlyCloudy", "partlyCloudy", "blowingDust", "foggy", "haze", "smoky":
                return "Cloudy"
                
            case "Windy", "Breezy":
                return "Windy"
                
            case "Drizzle", "HeavyRain", "Thunderstorm", "Rain", "SunShowers", "Scattered Thunderstorms", "strongStorms", "thunderstorms", "hurricane", "tropicalStorm", "hail":
                return "Rainy"
            
            default:
                print("\n\nError with Switch Statement: Check Model\n \(currentWeatherCondition)\n")
                return "sunny"
            }
            
        }
    }
    
    
    
}
