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

    enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
            case results
        }
}
