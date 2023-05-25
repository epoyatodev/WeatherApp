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
    @State private var currentDate = Date()

    
    
    
    var body: some View {
        

        
        ZStack{
            if let weather = weather{
                
                
                VStack{
                    VStack(alignment: .leading, spacing: 5){
                        Text(weather.name)
                            .bold()
                            .font(.title)
                        Text("Today, \(currentDate.formatted(.dateTime.month().day().hour().minute()))")
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
                        Text("Weather Today")
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
        .onAppear{
            geeTimeForDayOrNight()
        }

        .onAppear(perform: startTimer)
        
    }

    
    func startTimer() {
            // Crear un temporizador que se dispara cada segundo
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                // Actualizar la fecha actual cada vez que se dispara el temporizador
                currentDate = Date()
            }
        }
    
    func geeTimeForDayOrNight() {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                // Actualizar la fecha actual cada vez que se dispara el temporizador
                getDayOrNight()
            }
        

       
    }
    
    func getDayOrNight()  {
        if let weather = weather {
            let timestamp = weather.sys.sunset
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            
            let calendar = Calendar.current
            
            if let sunsetHour = calendar.dateComponents([.hour], from: date).hour,
               let currentHour = calendar.dateComponents([.hour], from: currentDate).hour {
                
                if currentHour > sunsetHour {
                    // La hora actual es posterior a la hora del atardecer
                    self.dia = false
                } else {

                    // La hora actual es anterior o igual a la hora del atardecer
                    self.dia = true
                }
            }
        }


    }
    
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: previewWeather, dia: true)
    }
}
