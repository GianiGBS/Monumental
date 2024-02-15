//
//  MockLocationService.swift
//  MonumentalTests
//
//  Created by Giovanni Gabriel on 14/02/2024.
//

//import Foundation
//import CoreLocation
//
//class MockLocationService: CLLocationManager {
//    private var _authorizationStatus: CLAuthorizationStatus = .notDetermined
//    var simulateGeocoderError: Bool = false
//    var issUpdatingLocation: Bool = false
//    
//    // Simuler la propriété authorizationStatus avec une méthode
//    func authorizationStatus() -> CLAuthorizationStatus {
//        return _authorizationStatus
//    }
//    
//    // Permettre la modification du status d'autorisation pour les tests
//    func setAuthorizationStatus(_ status: CLAuthorizationStatus) {
//        _authorizationStatus = status
//    }
//}
import Foundation
import CoreLocation

import CoreLocation

class MockLocationManager: CLLocationManager {
    private var _authorizationStatus: CLAuthorizationStatus = .notDetermined
    var simulateGeocoderError: Bool = false
    var isUpdatingLocation: Bool = false
    var authorizationStatusRequested: Bool = false
    var simulateSuccessResponse: Bool = false

    override var authorizationStatus: CLAuthorizationStatus {
        return _authorizationStatus
    }

    override func requestWhenInUseAuthorization() {
        authorizationStatusRequested = true
        // Ici, vous pouvez également simuler le changement d'état d'autorisation si nécessaire
    }

    override func startUpdatingLocation() {
        isUpdatingLocation = true
    }

    override func stopUpdatingLocation() {
        isUpdatingLocation = false
    }

    func setAuthorizationStatus(_ status: CLAuthorizationStatus) {
        _authorizationStatus = status
    }

    // Ajoutez une méthode pour simuler le comportement de getDepartmentName
    func simulateGetDepartmentName(for location: CLLocation, completion: @escaping (String?, Error?) -> Void) {
        if simulateGeocoderError {
            completion(nil, NSError(domain: "GeocoderError", code: 500, userInfo: nil))
        } else if simulateSuccessResponse {
            completion("Paris", nil)
        } else {
            // Gérer d'autres scénarios si nécessaire
        }
    }
}
