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
    
    private let weatherService = WeatherService()
    
}
