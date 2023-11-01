//
//  ExploreServiceTests.swift
//  MonumentalTests
//
//  Created by Giovanni Gabriel on 01/11/2023.
//

import XCTest
import Alamofire
@testable import Monumental

final class ExploreServiceTests: XCTestCase {

    private var exploreService: ExploreService!

    func testGetLandmarkWithValidDepartement() {
        // Given
        let mockedResult = MockedResult(response: MockedData.responseOK,
                                        data: MockedData.recipesCorrectData,
                                        error: nil)
        // When
        let mockedSession = MockExploreSession(mockedResult: mockedResult)

        // Then
        exploreService = ExploreService(session: mockedSession)

        exploreService.getLandmark(for: "Martinique") { landmark, error in
            XCTAssert(landmark != nil) // Reponse should be nil
            XCTAssert(error == nil) // No error should occur
        }
    }

    func testGetLandmarkWithEmptyReponse() {
        // Given
        let mockedResult = MockedResult(response: MockedData.responseOK,
                                        data: nil,
                                        error: nil)

        // When
        let mockedSession = MockExploreSession(mockedResult: mockedResult)

        // Then
        exploreService = ExploreService(session: mockedSession)

        exploreService.getLandmark(for: "Martinique") { landmark, error in
            XCTAssert(landmark == nil) // Reponse should be nil
            XCTAssert(error == nil ) // No error should occur
        }
    }

    func testGetLandmarkWithInvalidResponse() {
        // Given
        let mockedResult = MockedResult(response: MockedData.responseOK,
                                        data: MockedData.recipeIncorrectData,
                                        error: nil)

        // When
        let mockedSession = MockExploreSession(mockedResult: mockedResult)

        // Then
        exploreService = ExploreService(session: mockedSession)

        exploreService.getLandmark(for: "Martinique") { landmark, error in
            XCTAssert(landmark == nil) // Reponse should be nil
            XCTAssert(error != nil ) // Error should occur
        }
    }

    func testGetLandmarkWithAPIError() {
        // Given
        let apiError = NSError(domain: "fr.data.culture.gouv", code: 500, userInfo: nil)
        let mockedResult = MockedResult(response: nil,
                                        data: nil,
                                        error: apiError)

        // When
        let mockedSession = MockExploreSession(mockedResult: mockedResult)

        // Then
        exploreService = ExploreService(session: mockedSession)

        exploreService.getLandmark(for: "Martinique") { landmark, error in
            XCTAssert(landmark == nil) // Reponse should be nil du to API's error
            XCTAssert(error != nil ) // Error should occur
        }
    }

    func testGetLandmarkWithEmptyIngredients() {
        // Given
        let mockedResult = MockedResult(response: MockedData.responseOK,
                                        data: MockedData.recipesCorrectData,
                                        error: nil)

        // When
        let mockedSession = MockExploreSession(mockedResult: mockedResult)

        // Then
        exploreService = ExploreService(session: mockedSession)

        exploreService.getLandmark(for: "") { landmark, error in
            XCTAssert(landmark == nil) // Reponse should be nil du to error
            XCTAssert(error == nil ) // No error should occur
        }
    }
}
