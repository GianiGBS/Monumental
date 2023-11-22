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
            locationService = CoreLocationService.sharedInstance
        }

        override func tearDown() {
            locationService = nil
            super.tearDown()
        }

    // MARK: - Tests
        func testGetDepartmentName() {
            let expectation = XCTestExpectation(description: "Reverse geocoding")

            let coordinates = CLLocationCoordinate2D(latitude: 48.8566,
                                                     longitude: 2.3522) // For Paris, France Location
            let location = CLLocation(coordinate: coordinates,
                                      altitude: 0,
                                      horizontalAccuracy: 0,
                                      verticalAccuracy: 0,
                                      timestamp: Date())

            locationService.getDepartmentName(for: location) { department, error in
                XCTAssertNotNil(department, "Department name should not be null.")
                XCTAssertNil(error, "No reverse geocoding errors should be returned.")
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 5.0)
        }

        func testGetDepartmentNameForInvalidLocation() {
            let expectation = XCTestExpectation(description: "Reverse geocoding for an invalid location")

            // Utilisation de coordonnées qui ne correspondent à aucun emplacement réel
            let coordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            let location = CLLocation(coordinate: coordinates,
                                      altitude: 0,
                                      horizontalAccuracy: 0,
                                      verticalAccuracy: 0,
                                      timestamp: Date())

            locationService.getDepartmentName(for: location) { department, error in
                XCTAssertNil(department, "Department name should be null for an invalid location.")
                XCTAssertNil(error, "No reverse geocoding errors should be returned.")
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 5.0)
        }

}