//
//  CoreLocationService.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 23/10/2023.
//

import Foundation
import CoreLocation

class CoreLocationService: NSObject, CLLocationManagerDelegate {

    // MARK: - Singleton
    static var shared = CoreLocationService()

    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    var currentDepartment = ""
    weak var delegate: CorelocationServiceDelegate?

    // MARK: - Methods
    func getLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    // MARK: - Get location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                currentLocation = location

                let dispatchGroup = DispatchGroup()
                dispatchGroup.enter()
                
                // Call to get departement from location
                getDepartmentName(for: location) { departmentName, error in
                    if let department = departmentName {
                        self.currentDepartment = "\(department)"
                        print("User is located in : \(department)")

                    } else if let error = error {
                        print("Reverse geocoding error : \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
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
                    if let department = placemark.subAdministrativeArea {
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
