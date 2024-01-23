//
//  Landmark.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 23/10/2023.

import Foundation

// MARK: - Landmark
struct Landmark: Decodable {
    let reference: String?
    let datationDeLEdifice: String?
    let denominationDeLEdifice: String?
    let descriptionDeLEdifice: String?
    let historique: String?

    let region: [String]?
    let departementEnLettres: [String]?

    let formatAbregeDuSiecleDeConstruction: String?
    let statutJuridiqueDeLEdifice: String?
    let titreEditorialDeLaNotice: String?
    let adresseFormeEditoriale: String?
    let communeFormeEditoriale: String?

    let coordonneesAuFormatWgs84: CoordonneesWgs84?
    
    enum CodingKeys: String, CodingKey {
        case reference
        case datationDeLEdifice = "datation_de_l_edifice"
        case denominationDeLEdifice = "denomination_de_l_edifice"
        case descriptionDeLEdifice = "description_de_l_edifice"
        case historique
        
        case region
        case departementEnLettres = "departement_en_lettres"
        
        case formatAbregeDuSiecleDeConstruction = "format_abrege_du_siecle_de_construction"
        case statutJuridiqueDeLEdifice = "statut_juridique_de_l_edifice"
        case titreEditorialDeLaNotice = "titre_editorial_de_la_notice"
        case adresseFormeEditoriale = "adresse_forme_editoriale"
        case communeFormeEditoriale = "commune_forme_editoriale"
                
        
        case coordonneesAuFormatWgs84 = "coordonnees_au_format_wgs84"
    }
}

// MARK: - CoordonneesAuFormatWgs84
struct CoordonneesWgs84: Decodable {
    let lon: Double?
    let lat: Double?
}

