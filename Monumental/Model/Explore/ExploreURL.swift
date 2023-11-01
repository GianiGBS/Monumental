//
//  ExploreURL.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 23/10/2023.
// swiftlint:disable line_length

import Foundation

// MARK: - Explore API URL
class ExploreURL {
    static func endpoint(departement: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "data.culture.gouv.fr"
        components.path = "/api/explore/v2.1/catalog/datasets/liste-des-immeubles-proteges-au-titre-des-monuments-historiques/records"
        components.queryItems = [
            URLQueryItem(name: "limit", value: "20"),
            URLQueryItem(name: "refine", value: "departement_en_lettres:\(departement)")
            ]
        return components.url
    }
}
