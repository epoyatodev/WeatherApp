//
//  ContentView.swift
//  WeatherApp
//
//  Created by Enrique Poyato Ortiz on 20/5/23.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    
    var latitude = UserDefaults.standard.string(forKey: "Latitude")
    var longitude = UserDefaults.standard.string(forKey: "Longitude")
    
    var body: some View {
        VStack {
            if UserDefaults.standard.object(forKey: "Longitude") != nil{
                if let location = locationManager.getCoordinatesFromUserDefaults() {
                    if let weather = weather{
                        WeatherView(weather: weather, dia: false)
                    }else {
                        LoadingView()
                            .task {
                                do{
                                    weather =  try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                                }catch{
                                    print("Error getting Weather: \(error)")
                                }
                            }
                    }
                }
                
            }else{
                if locationManager.isLoading{
                    LoadingView()
                }else {
                    
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }

            
        }
        .background(Color(hue: 0.674, saturation: 0.738, brightness: 0.451))
        .preferredColorScheme(.dark)
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
