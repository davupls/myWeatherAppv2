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
    @Published private(set) var currentLocationTemperature = String()
    @Published private(set) var deviceLocationWeatherCondition = String()
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
                    self.currentLocationTemperature = weather.currentWeather.temperature.formatted()
                    
                }
                
                print(self.currentLocationTemperature)
            } catch {
                print("\nRetrieving Weather failed: \n \(error.localizedDescription)\n\n")
            }
        }
    }
    
    
    
    
}
