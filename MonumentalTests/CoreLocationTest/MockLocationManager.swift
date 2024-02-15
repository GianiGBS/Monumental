//
//  MockLocationService.swift
//  MonumentalTests
//
//  Created by Giovanni Gabriel on 14/02/2024.
//

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

    func simulateGetDepartmentName(for location: CLLocation, completion: @escaping (String?, Error?) -> Void) {
        if simulateGeocoderError {
            completion(nil, NSError(domain: "GeocoderError", code: 500, userInfo: nil))
        } else if simulateSuccessResponse {
            completion("Paris", nil)
        } else {
        }
    }
}
