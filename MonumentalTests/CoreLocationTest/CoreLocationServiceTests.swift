//
//  CoreLocationServiceTests.swift
//  MonumentalTests
//
//  Created by Giovanni Gabriel on 13/11/2023.
//

import XCTest
import CoreLocation
@testable import Monumental

final class CoreLocationServiceTests: XCTestCase {
    // MARK: - Properties
    var locationService: CoreLocationService!
    var mockLocationManager: MockLocationManager!

    // MARK: - Setup and Teardown
    override func setUp() {
        super.setUp()
        mockLocationManager = MockLocationManager()
        locationService = CoreLocationService(locationManager: mockLocationManager)
    }

    override func tearDown() {
        locationService = nil
        mockLocationManager = nil
        super.tearDown()
    }

    // MARK: - Tests
    // Test with valid location
    func testGetDepartmentNameWithValidLocation() {
            let expectation = XCTestExpectation(description: "Reverse geocoding for valid location using mock")

            // Configurer le mock pour simuler une réponse réussie
            mockLocationManager.simulateSuccessResponse = true
            let coordinates = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522) // Paris, France Location
            let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)

            // Simuler le changement d'autorisation si nécessaire
            mockLocationManager.setAuthorizationStatus(.authorizedWhenInUse)

            // Effectuer le test
            locationService.getDepartmentName(for: location) { department, error in
                XCTAssertEqual(department, "Paris", "Expected department name to be 'Paris' from mock.")
                XCTAssertNil(error, "No reverse geocoding errors should be returned from mock.")
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 5.0)
        }
    // Test with invalid location
    func testGetDepartmentNameForInvalidLocationUsingMock() {
            let expectation = XCTestExpectation(description: "Reverse geocoding for an invalid location using mock")

            // Configurer le mock pour simuler une situation d'erreur
            mockLocationManager.simulateGeocoderError = true
            let invalidCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0) // Coordonnées invalides
            let invalidLocation = CLLocation(latitude: invalidCoordinates.latitude, longitude: invalidCoordinates.longitude)

            // Effectuer le test
            locationService.getDepartmentName(for: invalidLocation) { department, error in
                XCTAssertNil(department, "Department name should be null for an invalid location.")
                XCTAssertNotNil(error, "An error should be returned for an invalid location.")
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 5.0)
        }

    func testRequestLocationAuthorization_RequestsAuthorization() {
        locationService.requestLocationAuthorization()

        // Vérifier si requestWhenInUseAuthorization a été appelé
        XCTAssertTrue(mockLocationManager.authorizationStatusRequested)
    }

    func testStartUpdatingLocation_Authorized_StartsUpdating() {
        mockLocationManager.setAuthorizationStatus(.authorizedWhenInUse)

        locationService.startUpdatingLocation()

        XCTAssertTrue(mockLocationManager.isUpdatingLocation)
    }

    func testStopUpdatingLocation_StopsUpdating() {
        locationService.startUpdatingLocation()
        locationService.stopUpdatingLocation()

        XCTAssertFalse(mockLocationManager.isUpdatingLocation)
    }

    func testGetDepartmentName_Success_ReturnsDepartment() {
        let expectation = XCTestExpectation(description: "Successful geocoding returns department name")

        // Simuler une réponse réussie du géocodeur
        mockLocationManager.simulateSuccessResponse = true

        let testLocation = CLLocation(latitude: 48.8566, longitude: 2.3522) // Coordonnées de Paris
        locationService.getDepartmentName(for: testLocation) { departmentName, error in
            XCTAssertEqual(departmentName, "Paris")
            XCTAssertNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testGetDepartmentName_Failure_ReturnsError() {
        let expectation = XCTestExpectation(description: "Geocoding failure returns error")

        // Simuler une erreur de géocodeur
        mockLocationManager.simulateGeocoderError = true

        let testLocation = CLLocation(latitude: 0, longitude: 0) // Coordonnées invalides
        locationService.getDepartmentName(for: testLocation) { departmentName, error in
            XCTAssertNil(departmentName)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
