//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Enrique Poyato Ortiz on 20/5/23.
//

import SwiftUI

struct WeatherView: View {
    
    var weather: ResponseBody?
    @StateObject var locationManager = LocationManager()
    @State var dia: Bool
    @State private var isScaled = false
    @State var isRotated = true
    @State private var offsetX: CGFloat = 0
    
    
    
    var body: some View {
        
        let tapGesture = TapGesture()
            .onEnded { _ in
                withAnimation {
                    isScaled.toggle()
                }
            }
        
        ZStack{
            if let weather = weather{
                
                
                VStack{
                    VStack(alignment: .leading, spacing: 5){
                        Text(weather.name)
                            .bold()
                            .font(.title)
                        Text("Hoy, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                            .fontWeight(.light)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    
                    VStack{
                        HStack {
                            VStack(spacing: 20){
                                Image(systemName: weatherConditions[Int(weather.weather[0].id)]!)
                                    .font(.system(size: 40))
                                
                                Text(weather.weather[0].main)
                            }
                            .frame(width: 150, alignment: .leading)
                            
                            Spacer()
                            
                            Text(weather.main.temp.roundDouble() + "º")
                                .font(.system(size: 100))
                                .bold()
                                .padding()
                        }
                        
                        Spacer()
                            .frame(height: 40)
                        
                        Image(dia ? "clouds" : "")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 280)
                        
                            .offset(x: offsetX)
                            .onAppear {
                                withAnimation(Animation.linear(duration: 90).repeatForever(autoreverses: true)) {
                                    offsetX = UIScreen.main.bounds.width - 50
                                }
                            }
                        
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack{
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 20){
                        Text("Tiempo Hoy")
                            .bold()
                            .padding(.bottom)
                        
                        HStack{
                            WeatherRow(logo: "thermometer", name: "Min temp", value: weather.main.temp_min.roundDouble() + "º")
                            
                            Spacer()
                            
                            WeatherRow(logo: "thermometer", name: "Max temp", value: weather.main.temp_max.roundDouble() + "º")
                            
                        }
                        
                        HStack{
                            WeatherRow(logo: "wind", name: "Viento", value: weather.wind.speed.roundDouble() + " m/s")
                            
                            Spacer()
                            
                            WeatherRow(logo: "humidity", name: "Humedad", value: weather.main.humidity.roundDouble() + "%")
                            
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.bottom, 20)
                    .foregroundColor(Color(hue: 0.674, saturation: 0.738, brightness: 0.451))
                    .background(.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(
            Image(dia ? "day" : "night")
                .resizable()
                .frame(width: 1000, height: 1000)
            
            
        )
        .preferredColorScheme(.dark)
        .onAppear(perform: getDayOrNight)
        
    }
    
    func getDayOrNight()  {
        if let weather = weather{
            let timestamp = weather.sys.sunset
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            let formattedDate = dateFormatter.string(from: date)
            
            print(formattedDate)
            
            let currentDate = Date()
            
            guard let formattedDate = dateFormatter.date(from: formattedDate) else {
                return
            }
            
            if formattedDate.compare(currentDate) == .orderedAscending {
                print("Night")
                self.dia = false
            } else {
                self.dia = true
            }
            
        }
    }
    
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: previewWeather, dia: true)
    }
}
