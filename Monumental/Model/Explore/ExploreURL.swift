//
//  ExploreURL.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 23/10/2023.

import Foundation

// MARK: - Explore API URL
class ExploreURL {

    // MARK: - Properties
    static let baseURL = "data.culture.gouv.fr"
    static let path = "/api/explore/v2.1/catalog/datasets/liste-des-immeubles-proteges-au-titre-des-monuments-historiques/records"
    static let limit = "20"
    static let refineKey = "departement_en_lettres"

    // MARK: - Methods
    static func endpoint(departement: String?) -> URL? {
        guard let department = departement else { return nil }

        var components = URLComponents()
        components.scheme = "https"
        components.host = baseURL
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "limit", value: limit),
            URLQueryItem(name: "refine", value: "\(refineKey):\(department)")
        ]

        return components.url
    }
}
