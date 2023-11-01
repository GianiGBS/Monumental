//
//  MockedData.swift
//  MonumentalTests
//
//  Created by Giovanni Gabriel on 31/10/2023.
//

import Foundation

public final class MockedData {

    // MARK: - Data
        static var recipesCorrectData: Data? {
        let bundle = Bundle(for: MockedData.self)
        let url = bundle.url(forResource: "Landmark", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        return data!
    }

    static let recipeIncorrectData = "erreur".data(using: .utf8)!

    // MARK: - Response

    static let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!,
                                            statusCode: 200,
                                            httpVersion: nil,
                                            headerFields: nil)!

    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!,
                                            statusCode: 500,
                                            httpVersion: nil,
                                            headerFields: nil)!
}
