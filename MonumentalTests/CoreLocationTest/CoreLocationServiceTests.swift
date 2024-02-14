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

    // MARK: - Setup and Teardown
    override func setUp() {
        super.setUp()
        locationService = CoreLocationService()
    }

    override func tearDown() {
        locationService = nil
        super.tearDown()
    }

    // MARK: - Tests
    // Test with valid location
    func testGetDepartmentNameWithValidLocation() {
        let expectation = XCTestExpectation(description: "Reverse geocoding for valid location")

        let coordinates = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522) // Paris, France Location
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)

        locationService.getDepartmentName(for: location) { department, error in
            XCTAssertEqual(department, "Paris", "Expected department name to be 'Paris'.")
            XCTAssertNil(error, "No reverse geocoding errors should be returned.")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    // Test with invalid location
    func testGetDepartmentNameForInvalidLocation() {
        let expectation = XCTestExpectation(description: "Reverse geocoding for an invalid location")

        let coordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0) // Invalid location
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)

        locationService.getDepartmentName(for: location) { department, error in
            XCTAssertNil(department, "Department name should be null for an invalid location.")
            // Ici, on pourrait vérifier un type d'erreur spécifique si votre implémentation le permet
            XCTAssertNotNil(error, "Expected error for invalid location.")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

}
