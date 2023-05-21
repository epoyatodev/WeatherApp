//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Enrique Poyato Ortiz on 20/5/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate{
    var managerLocation = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    @Published var isDay = true
    @Published var locationStatus: CLAuthorizationStatus?
    
    
    override init() {
        super.init()
        managerLocation.delegate = self
    }
    
    
    
    
    func requestLocation(){
        isLoading = true
        managerLocation.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        saveCoordinatesUserDefaults(location: location!)
        
        isLoading = false
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location", error)
        isLoading = false
    }
    
    func checkLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            managerLocation.requestWhenInUseAuthorization()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationStatus = manager.authorizationStatus
    }
    
    func saveCoordinatesUserDefaults(location: CLLocationCoordinate2D) {
        UserDefaults.standard.set(String(format: "%.6f", location.latitude), forKey: "Latitude")
        UserDefaults.standard.set(String(format: "%.6f", location.longitude), forKey: "Longitude")
    }
    
    func getCoordinatesFromUserDefaults() -> CLLocationCoordinate2D? {
        guard let latitudeString = UserDefaults.standard.string(forKey: "Latitude"),
              let longitudeString = UserDefaults.standard.string(forKey: "Longitude"),
              let latitude = Double(latitudeString),
              let longitude = Double(longitudeString) else {
            return nil
        }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
 
}
