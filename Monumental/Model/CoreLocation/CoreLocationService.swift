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
    //    static var shared = CoreLocationService()
    
    // MARK: - Properties
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    var currentDepartment = ""
    weak var delegate: CorelocationServiceDelegate?
    
    // MARK: - Init
    init(locationManager:CLLocationManager = CLLocationManager()){
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    // MARK: - Methods
    func getLocation() {
    }
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // Call to get departement from location
        getDepartmentName(for: location) { [weak self] departmentName, error in
            DispatchQueue.main.async {
                if let department = departmentName {
                    self?.delegate?.didUpdateDepartment(department)
                    self?.currentDepartment = "\(department)"
                    print("User is located in : \(department)")
                } else if let error = error {
                    self?.delegate?.didFailWithError(error)
                    print("Reverse geocoding error : \(error.localizedDescription)")
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.delegate?.didFailWithError(error)
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
            
            let department = placemarks?.first?.subAdministrativeArea
            completion(department, department ==  nil ? LocationErrors.noDepartment:  nil)
            
        }
    }
    enum LocationErrors: Error {
        case noDepartment
    }
}
