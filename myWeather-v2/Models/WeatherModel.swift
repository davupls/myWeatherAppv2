//
//  WeatherModel.swift
//  myWeather-v2
//
//  Created by David Mclean on 6/18/23.
//

import Foundation
import WeatherKit

public class WeatherModel: ObservableObject {
    @Published private(set) var currentLocationTemperature = String()
    @Published private(set) var deviceLocationWeatherCondition = String()
    @Published private(set) var forecastWeekDays = Array<Date>()
    @Published private(set) var weatherForecast  = Array<WeatherCondition>()
    @Published private(set) var isLoaded = false
    
    private let weatherService = WeatherService()
    private var deviceLocationModel: DeviceLocationModel
    
    init(deviceLocationModel: DeviceLocationModel) {
        self.deviceLocationModel = deviceLocationModel
    }
    
    func getweather() {
        Task {
            do {
                let weather = try await weatherService.weather(for: deviceLocationModel.location!)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
