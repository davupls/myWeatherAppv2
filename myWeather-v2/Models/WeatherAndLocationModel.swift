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
    @Published private(set) var userDeviceLocation = String()
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
        locationManager.desiredAccuracy = kCLLocationAccuracyReduced

    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
        
    }
    
    //    Fetches Device Coordinates
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        processLocation()
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
    
    // MARK: Get Device Location and Area Name
    func getLocationName(for coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let placemark = placemarks?.first,
               let locality  = placemark.locality
            {
                let locationName = "\(locality)"
                completion(locationName)
            } else {
                print("No placemarks found.")
                completion(nil)
            }
        }
    }
    
    // MARK: Process Location
    func processLocation() {
        
        if let userLocation = locationManager.location?.coordinate {
            getLocationName(for: userLocation) { locationName in
                if let locationName = locationName {
                    print(userLocation)
                    print("User location name: \(locationName)")
                    self.userDeviceLocation = locationName
                } else {
                    print("Failed to retireve location name.")
                }
            }
        } else {
            print("Failed to retrieve user location.")
        }
        
    }
    
    
    
}
