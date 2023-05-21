//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Enrique Poyato Ortiz on 20/5/23.
//

import Foundation
import CoreLocation

let weatherConditions: [Int: String] = [
    200: "cloud.bolt.rain.fill",
    201: "cloud.bolt.rain.fill",
    202: "cloud.bolt.rain.fill",
    210: "cloud.bolt.fill",
    211: "cloud.bolt.fill",
    212: "cloud.bolt.fill",
    221: "cloud.bolt.fill",
    230: "cloud.bolt.rain.fill",
    231: "cloud.bolt.rain.fill",
    232: "cloud.bolt.rain.fill",
    300: "cloud.drizzle.fill",
    301: "cloud.drizzle.fill",
    302: "cloud.drizzle.fill",
    310: "cloud.drizzle.fill",
    311: "cloud.drizzle.fill",
    312: "cloud.drizzle.fill",
    313: "cloud.drizzle.fill",
    314: "cloud.heavyrain.fill",
    321: "cloud.drizzle.fill",
    500: "cloud.rain.fill",
    501: "cloud.rain.fill",
    502: "cloud.rain.fill",
    503: "cloud.rain.fill",
    504: "cloud.heavyrain.fill",
    511: "cloud.sleet.fill",
    520: "cloud.rain.fill",
    521: "cloud.rain.fill",
    522: "cloud.rain.fill",
    531: "cloud.rain.fill",
    600: "snow",
     601: "cloud.snow.fill",
     602: "cloud.snow.fill",
     611: "cloud.sleet.fill",
     612: "cloud.sleet.fill",
     613: "cloud.sleet.fill",
     615: "cloud.snow.fill",
     616: "cloud.snow.fill",
     620: "cloud.snow.fill",
     621: "cloud.snow.fill",
     622: "cloud.snow.fill",
     701: "sun.haze.fill",
     711: "smoke.fill",
     721: "sun.haze.fill",
     731: "sun.dust.fill",
     741: "cloud.fog.fill",
     751: "sun.dust.fill",
     761: "sun.dust.fill",
     762: "smoke.fill",
     771: "wind",
     781: "tornado",
     800: "sun.max.fill",
     801: "cloud.sun.fill",
     802: "cloud.sun.fill",
     803: "cloud.fill",
     804: "cloud.fill"
]

class WeatherManager{
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=b8734d7f23f13d125b134be785ff3d14&units=metric") else { fatalError("Missing URL") }
        print(url)
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard(response as? HTTPURLResponse)?.statusCode  == 200 else { fatalError("Error fetching weather data") }
        
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        
        return decodedData
    }
    
    
}
struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse
    var sys: Sys
    
    
    struct Sys: Codable {
        let country: String
        let sunrise, sunset: Int
    }

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}
