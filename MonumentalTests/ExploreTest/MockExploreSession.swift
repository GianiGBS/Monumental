//
//  MockExploreSession.swift
//  MonumentalTests
//
//  Created by Giovanni Gabriel on 31/10/2023.
//

import Foundation
import Alamofire
@testable import Monumental

struct MockedResult {
    var response: HTTPURLResponse?
    var data: Data?
    var error: Error?
}

final class MockExploreSession: AFSession {

    // MARK: - Properties
    private let mockedResult: MockedResult

    // MARK: - Initialization
    init(mockedResult: MockedResult) {
        self.mockedResult = mockedResult
    }

    // MARK: - Methods
    func request(url: URL,
                 method: Alamofire.HTTPMethod,
                 completionHandler: @escaping (Alamofire.AFDataResponse<Data>) -> Void) {
        let httpResponse = mockedResult.response
        let data = mockedResult.data
        let error = mockedResult.error
        let result: Result<Data, AFError>
        if let error = error {
            let afError = AFError.sessionTaskFailed(error: error)
            result = .failure(afError)
        } else {
            if let data = data {
                result = .success(data)
            } else {
                let afError = AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
                result = .failure(afError)
            }
        }

        // Create an AFDataResponse object
        let dataResponse = AFDataResponse<Data>(
            request: nil,
            response: httpResponse,
            data: data,
            metrics: nil,
            serializationDuration: 0,
            result: result
        )

        // Call the completion with the mock response
        completionHandler(dataResponse)
    }
}
