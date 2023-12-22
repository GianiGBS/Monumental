//
//  Landmark.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 23/10/2023.

import Foundation

// MARK: - Landmark
struct Landmark: Decodable {
    let reference: String?
    let natureDeLaProtection: String?
    let denominationDeLEdifice: String?
    let historique: String?
    let region: [String]?
    let departementEnLettres: [String]?
    let coordonneesWgs84: CoordonneesWgs84?
}

// MARK: - CoordonneesAuFormatWgs84
struct CoordonneesWgs84: Decodable {
    let lon: Double?
    let lat: Double?
}
