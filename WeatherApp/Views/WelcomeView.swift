//
//  WelcomeView.swift
//  WeatherApp
//
//  Created by Enrique Poyato Ortiz on 20/5/23.
//

import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    @EnvironmentObject var locationManager: LocationManager
    var body: some View {
        VStack{
            VStack(spacing: 20){
                Text("Welcome to Weather App")
                    .font(.title)
                    .bold()
                Text("Please share your location to get the current weather in your area.")
                    .padding()
            }
            .multilineTextAlignment(.center)
            .padding()
            
            LocationButton(.shareCurrentLocation){
                locationManager.requestLocation()
                

            }
            .cornerRadius(30)
            .symbolVariant(.fill)
            .foregroundColor(.white)
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
