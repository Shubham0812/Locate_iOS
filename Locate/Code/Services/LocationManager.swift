//
//  LocationManager.swift
//  Locate
//
//  Created by Shubham Singh on 22/11/20.
//

import CoreLocation

enum PermissionStatus {
    case granted
    case restricted
    case unknown
}

class LocationManager: NSObject {
    
    // MARK:- variables
    static var shared: LocationManager = {
        return LocationManager()
    }()
    
    var clManager: CLLocationManager!
    
    var currentCity: BoxBind<String?> = BoxBind(nil)
    var currentCountry: BoxBind<String?> = BoxBind(nil)
    var currentStateCode: BoxBind<String?> = BoxBind(nil)
    
    var permissionStatus: BoxBind<PermissionStatus> = BoxBind(.unknown)
    
    override init() {
        super.init()
        clManager = CLLocationManager()
        clManager.delegate = self
    }
    
    // MARK:- functions for the viewController
    func requestPermissionIfRequired() {
        clManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            print("Location access blocked")
            
            self.permissionStatus.value = .restricted
            
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permission granted")
            getLocationForUser(location: manager.location)
            
            self.permissionStatus.value = .granted
            
        @unknown default:
            break
        }
    }
    
    private func getLocationForUser(location: CLLocation?) {
        guard let location = location else { return }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { [self] (placemarks, error) in
            if (error == nil) {
                guard let placemarks = placemarks else { return }
                let placemark = placemarks[0]
                currentCity.value = placemark.locality
                currentCountry.value = placemark.country
                currentStateCode.value = placemark.isoCountryCode
                print(placemark.inlandWater, placemark.country, placemark.administrativeArea, placemark.locality, placemark.location)
            } else {
                // handle error, notify the views through a boxed var
            }
        }
    }
}
