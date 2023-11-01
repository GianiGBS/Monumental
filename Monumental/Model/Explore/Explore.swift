//
//  Explore.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 23/10/2023.
//

import Foundation

// MARK: - Explore
struct Explore: Decodable {
    let totalCount: Int?
    let results: [Landmark]?
}

// MARK: - CoordonneesAuFormatWgs84
struct CoordonneesAuFormatWgs84: Decodable {
    let lon, lat: Double?
}
