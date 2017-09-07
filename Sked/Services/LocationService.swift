//
//  LocationService.swift
//  Sked
//
//  Created by TJ Barber on 9/6/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    static let sharedInstance = LocationService()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        
        self.locationManager.delegate = self
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        if authorizationStatus == .authorizedAlways {
            self.requestLocation()
        }
    }
    
    func requestLocation() {
        self.locationManager.requestLocation()
    }
}

// MARK: - Core Location Delegate

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            self.locationManager.requestLocation()
        default:
            print("\(status)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fatalError(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("location locked on")
            self.currentLocation = location.coordinate
        }
    }
}
