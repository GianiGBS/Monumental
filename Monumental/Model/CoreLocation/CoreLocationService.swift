//
//  CoreLocationService.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 23/10/2023.
//

import Foundation
import CoreLocation

class CoreLocationService: NSObject, CLLocationManagerDelegate {

    // MARK: - Properties
    static var sharedInstance = CoreLocationService()
    private let location = CLLocationManager()
    private var currentLocation: CLLocation?

    // MARK: - Initialization

    // MARK: - Methods

    // MARK: -
    func getLocation() {
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
    }
    // MARK: - Get location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                currentLocation = location

                // Call to get departement from location
                getDepartmentName(for: location) { departmentName, error in
                    if let department = departmentName {
                        print("User is located in : \(department)")

                    } else if let error = error {
                        print("Reverse geocoding error : \(error.localizedDescription)")
                    }
                }
            }
        }

    // MARK: - Get Department name from location
        func getDepartmentName(for location: CLLocation, completion: @escaping (String?, Error?) -> Void) {
            let geocoder = CLGeocoder()

            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    completion(nil, error)
                    return
                }

                if let placemark = placemarks?.first {
                    if let department = placemark.administrativeArea {
                        completion(department, nil)
                    } else {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, nil)
                }
            }
        }
    }
