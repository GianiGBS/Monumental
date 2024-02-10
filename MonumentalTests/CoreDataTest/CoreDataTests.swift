//
//  CoreDataTests.swift
//  MonumentalTests
//
//  Created by Giovanni Gabriel on 26/01/2024.
//

import XCTest
import CoreData
@testable import Monumental

class CoreDataManagerTests: XCTestCase {

    // MARK: - Properties
    var coreDataStack: CoreDataStackTest!
    var coreDataManager: CoreDataManager!

    // MARK: - Setup and Teardown
    override func setUpWithError() throws {
        try super.setUpWithError()
        coreDataStack = CoreDataStackTest.sharedTinstance
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }

    override func tearDownWithError() throws {
        coreDataStack = nil
        coreDataManager = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Tests

    func testAddMonumentToFavorites() {
        // Given
        let monument = Landmark(reference: "12345",
                                datationDeLEdifice: "date",
                                denominationDeLEdifice: "denomination",
                                descriptionDeLEdifice: "description",
                                historique: "historique",
                                lienVersLaBaseArchivMh: "lien",
                                region: ["region"],
                                departementEnLettres: ["departement"],
                                formatAbregeDuSiecleDeConstruction: "siecle",
                                statutJuridiqueDeLEdifice: "statut",
                                titreEditorialDeLaNotice: "titre",
                                adresseFormeEditoriale: "adresse",
                                communeFormeEditoriale: "commune",
                                coordonneesAuFormatWgs84: CoordonneesWgs84(lon: 1.0, lat: 2.0))
        // When
        do {
            try coreDataManager.addMonumentToFav(monument: monument)
            let monuments = coreDataManager.fetchFavMonuments()
            // Then
            XCTAssertTrue(monuments.contains { $0.reference == "12345" })
        } catch {
            XCTFail("Adding monument to favorites failed with error: \(error.localizedDescription)")
        }
    }

    func testDeleteMonumentFromfavorites() {
        //  Given
        let monument = Landmark(reference: "12345",
                                datationDeLEdifice: "date",
                                denominationDeLEdifice: "denomination",
                                descriptionDeLEdifice: "description",
                                historique: "historique",
                                lienVersLaBaseArchivMh: "lien",
                                region: ["region"],
                                departementEnLettres: ["departement"],
                                formatAbregeDuSiecleDeConstruction: "siecle",
                                statutJuridiqueDeLEdifice: "statut",
                                titreEditorialDeLaNotice: "titre",
                                adresseFormeEditoriale: "adresse",
                                communeFormeEditoriale: "commune",
                                coordonneesAuFormatWgs84: CoordonneesWgs84(lon: 1.0, lat: 2.0))
        //  When
        do {
            try coreDataManager.addMonumentToFav(monument: monument)
            try coreDataManager.deleteOneFavMonument(reference: "12345")
            let monuments = coreDataManager.fetchFavMonuments()
            //  Then
            XCTAssertFalse(monuments.contains { $0.reference == "12345" })
        } catch {
            XCTFail("Deleting monument from favorites failed with error: \(error.localizedDescription)")
        }
    }

    func testCheckIfItemExist() {
        //  Given
        let monument = Landmark(reference: "12345",
                                datationDeLEdifice: "date",
                                denominationDeLEdifice: "denomination",
                                descriptionDeLEdifice: "description",
                                historique: "historique",
                                lienVersLaBaseArchivMh: "lien",
                                region: ["region"],
                                departementEnLettres: ["departement"],
                                formatAbregeDuSiecleDeConstruction: "siecle",
                                statutJuridiqueDeLEdifice: "statut",
                                titreEditorialDeLaNotice: "titre",
                                adresseFormeEditoriale: "adresse",
                                communeFormeEditoriale: "commune",
                                coordonneesAuFormatWgs84: CoordonneesWgs84(lon: 1.0, lat: 2.0))
        //   When
        do {
            try coreDataManager.addMonumentToFav(monument: monument)
            //  Then
            XCTAssertTrue(coreDataManager.checkIfItemExist(reference: "12345"))
            XCTAssertFalse(coreDataManager.checkIfItemExist(reference: "67810"))
        } catch {
            XCTFail("Error while testing checkIfItemExist: \(error.localizedDescription)")
        }
    }

    func testAddMonumentTwiceToFavorites() {
//        // Given
        let monument = Landmark(reference: "12345",
                                datationDeLEdifice: "date",
                                denominationDeLEdifice: "denomination",
                                descriptionDeLEdifice: "description",
                                historique: "historique",
                                lienVersLaBaseArchivMh: "lien",
                                region: ["region"],
                                departementEnLettres: ["departement"],
                                formatAbregeDuSiecleDeConstruction: "siecle",
                                statutJuridiqueDeLEdifice: "statut",
                                titreEditorialDeLaNotice: "titre",
                                adresseFormeEditoriale: "adresse",
                                communeFormeEditoriale: "commune",
                                coordonneesAuFormatWgs84: CoordonneesWgs84(lon: 1.0, lat: 2.0))

        // When
        do {
            try coreDataManager.addMonumentToFav(monument: monument)
            try coreDataManager.addMonumentToFav(monument: monument)

            let monuments = coreDataManager.fetchFavMonuments()

            // Then
            XCTAssertEqual(monuments.filter { $0.reference == "12345" }.count, 1)
        } catch {
            XCTFail("Adding the same monument twice to favorites failed with error: \(error.localizedDescription)")
        }
    }

    func testDeleteNonExistingMonumentFromFavorites() {
        // When
        do {
            try coreDataManager.deleteOneFavMonument(reference: "nonexistentRef")
            let monuments = coreDataManager.fetchFavMonuments()

            // Then
            // Ensure that deleting a non-existing monument does not change the favorites
            XCTAssertEqual(monuments.count, 0)
        } catch {
            XCTFail("Deleting a non-existing monument from favorites should not fail: \(error.localizedDescription)")
        }
    }

    func testDeleteAllMonumentsFromFavorites() {
//        // Given
        let monument1 = Landmark(reference: "12345",
                                datationDeLEdifice: "date",
                                denominationDeLEdifice: "denomination",
                                descriptionDeLEdifice: "description",
                                historique: "historique",
                                lienVersLaBaseArchivMh: "lien",
                                region: ["region"],
                                departementEnLettres: ["departement"],
                                formatAbregeDuSiecleDeConstruction: "siecle",
                                statutJuridiqueDeLEdifice: "statut",
                                titreEditorialDeLaNotice: "titre",
                                adresseFormeEditoriale: "adresse",
                                communeFormeEditoriale: "commune",
                                coordonneesAuFormatWgs84: CoordonneesWgs84(lon: 1.0, lat: 2.0))
        let monument2 = Landmark(reference: "678910",
                                datationDeLEdifice: "date2",
                                denominationDeLEdifice: "denomination",
                                descriptionDeLEdifice: "description",
                                historique: "historique",
                                lienVersLaBaseArchivMh: "lien2",
                                region: ["region"],
                                departementEnLettres: ["departement"],
                                formatAbregeDuSiecleDeConstruction: "siecle",
                                statutJuridiqueDeLEdifice: "statut",
                                titreEditorialDeLaNotice: "titre2",
                                adresseFormeEditoriale: "adresse2",
                                communeFormeEditoriale: "commune",
                                coordonneesAuFormatWgs84: CoordonneesWgs84(lon: 4.0, lat: 5.0))

        // When
        do {
            try coreDataManager.addMonumentToFav(monument: monument1)
            try coreDataManager.addMonumentToFav(monument: monument2)
            try coreDataManager.deleteAllFavMonuments()
            let monuments = coreDataManager.fetchFavMonuments()

            // Then
            XCTAssertEqual(monuments.count, 0)
        } catch {
            XCTFail("Deleting all monuments from favorites failed with error: \(error.localizedDescription)")
        }
    }

    func testFetchFavMonumentsWithEmptyFavorites() {
        // When
        let monuments = coreDataManager.fetchFavMonuments()

        // Then
        XCTAssertEqual(monuments.count, 0)
    }
}
