//
//  WeatherShapes.swift
//  myWeather-v2
//
//  Created by David Mclean on 6/19/23.
//

import SwiftUI

struct WeatherShapes: View {
    var body: some View {
        NavigationStack {
            VStack {
//                RainyWeatherShapes()
//                CloudyWeather()
//                WindyWeatherShapes()
                SunnyWeatherShapes()
                    .foregroundColor(.purple)
            }
            .navigationTitle("Weather Display")
            .padding(.vertical)
        }
    }
}

struct Circle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.size.width/2, startAngle: .degrees(170), endAngle: .degrees(180), clockwise: true)
        
        return path
    }
}

// MARK: Rainy
struct RainyWeatherShapes: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 350, height: 350)
                .foregroundColor(Color("soft-white"))
                .offset(x: 100,y: 30)
            Circle()
                .frame(width: 300, height: 300)
                .foregroundColor(Color("soft-red"))
                .offset(x: -100,y: 0)
            Circle()
                .frame(width: 300, height: 300)
                .foregroundColor(Color("soft-blue"))
                .offset(x: -10, y: -60)
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(Color("soft-orange"))
                .offset(x: -130,y: -80)
        }
    }
}



struct Cloud: Shape {
    
    func path(in rect: CGRect) -> Path {

        Path { path in
            let width: CGFloat = rect.width
            let height: CGFloat = rect.height
            
            path.move(to: CGPoint(x: 0 * width, y: 0 * height))
    
            path.addCurve(to: CGPoint(x: rect.width, y: rect.height), control1: CGPoint(x: width * 0.15, y: height * 1), control2: CGPoint(x: width * 1, y: height * 1))
    
            path.addLine(to: CGPoint(x: 2 * width, y: 1 * height))
            path.addLine(to: CGPoint(x: 4 * width, y: 0 * height))
            
            path.closeSubpath()
        }
    }
    
}

// MARK: Cloudy
struct CloudyWeatherShapes: View {
    var body: some View {
        ZStack {
            Cloud()
                .foregroundColor(Color(("soft-red")))
                .rotationEffect(Angle(degrees: -15))
            Cloud()
                .foregroundColor(Color(("soft-orange")))
                .rotationEffect(Angle(degrees: -15))
                .offset(x: 0, y: -50)
            Cloud()
                .foregroundColor(Color(("soft-white")))
                .rotationEffect(Angle(degrees: -15))
                .offset(x: 0, y: -100)
            Cloud()
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: -15))
                .offset(x: 0, y: -150)
        }
    }
}



struct Wind: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width  = rect.width
            let height = rect.height
            
            path.move(to: CGPoint(x: -0.3 * width, y: 0 * height))
            path.addCurve(
                to: CGPoint(x: 1.2 * width, y: 0 * height),
                control1: CGPoint(x: 0.3 * width, y: 0.3 * height),
                control2: CGPoint(x: 0.3 * width, y: 0.8 * height)
            )
            
            path.closeSubpath()
        }
    }
}

// MARK: Windy
struct WindyWeatherShapes: View {
    var body: some View {
        ZStack {
            Wind()
                .offset(x: 0, y: 90)
                .scale(1.8)
                .rotationEffect(Angle(degrees: 6))
                .foregroundColor(Color("soft-blue"))
            Wind()
                .offset(x: 45, y: 70)
                .scale(1.6)
                .rotationEffect(Angle(degrees: 6))
                .foregroundColor(Color("soft-red"))
            Wind()
                .offset(x: 90, y: 50)
                .scale(1.4)
                .rotationEffect(Angle(degrees: 6))
                .foregroundColor(Color("soft-orange"))
            Wind()
                .offset(x: 135, y: 30)
                .scale(1.2)
                .rotationEffect(Angle(degrees: 6))
                .foregroundColor(Color("soft-white"))
            
        }
    }
}



struct Sun: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width  = rect.width
            let height = rect.height
            
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.size.width/1.65, startAngle: .degrees(170), endAngle: .degrees(180), clockwise: true)
            
        }
    }
}

// MARK: Sunny
struct SunnyWeatherShapes: View {
    var body: some View {
        ZStack {
            Sun()
                .offset(x: 40, y: -110)
                .foregroundColor(Color("soft-orange"))
            Sun()
                .offset(x: 60, y: -120)
                .scale(0.76)
                .foregroundColor(Color("soft-red"))
            Sun()
                .offset(x: 115, y: -160)
                .scale(0.6)
                .foregroundColor(Color("soft-blue"))
            Sun()
                .offset(x: 225, y: -230)
                .scale(0.45)
                .foregroundColor(Color("soft-white"))
        }
    }
}

struct WeatherShapes_Previews: PreviewProvider {
    static var previews: some View {
        WeatherShapes()
    }
}
