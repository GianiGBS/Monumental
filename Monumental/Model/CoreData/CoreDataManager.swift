//
//  CoreDataManager.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 23/01/2024.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // MARK: - Properties
    var favMonuments: [Landmark] = []
    private let coreDataStack: CoreDataStack
    private let request: NSFetchRequest<CoreDataMonument> = CoreDataMonument.fetchRequest()
    public weak var delegate: ViewDelegate?
    
    // MARK: - Init
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
        self.coreDataStack = coreDataStack
    }
    // MARK: - Methods
    
    // MARK: Get all monuments
    func fetchFavMonuments() -> [Landmark] {
        favMonuments.removeAll()
        do {
            let coreDataMonuments = try coreDataStack.viewContext.fetch(request)
            favMonuments = coreDataMonuments.compactMap({convertCoreDataMonumentToMonument($0)}) }
        catch {
            delegate?.presentAlert(title: "Erreur", message: "Echec lors de la recupération des monuments")
        }
        return favMonuments
    }

    // MARK: - Refresh CoreData
        func refresh() {
            // Erase all Monuments form list
            favMonuments.removeAll()
            // Fetch all fav monuments from CoreData
            fetchFavMonuments()
            delegate?.updateView()
        }

    // MARK: Save a monument in CoreData
    func addMonumentToFav(monument: Landmark) throws {
        if let monumentReference = monument.reference {
            if checkIfItemExist(reference: monumentReference) {
                // If item exist delete first
                try deleteOneFavMonument(reference: monumentReference)
            }
        }
        let coreDataMonument = CoreDataMonument(context: coreDataStack.viewContext)
        coreDataMonument.reference = monument.reference
        coreDataMonument.adresseFormeEditoriale = monument.adresseFormeEditoriale
        coreDataMonument.communeFormeEditoriale = monument.communeFormeEditoriale
        coreDataMonument.datationDeLEdifice = monument.datationDeLEdifice
        coreDataMonument.denominationDeLEdifice = monument.denominationDeLEdifice
        coreDataMonument.departementEnLettres = monument.departementEnLettres?.joined(separator: ",")
        coreDataMonument.descriptionDeLEdifice = monument.descriptionDeLEdifice
        coreDataMonument.formatAbregeDuSiecleDeConstruction = monument.formatAbregeDuSiecleDeConstruction
        coreDataMonument.historique = monument.historique
        coreDataMonument.lienVersLaBaseArchivMh = monument.lienVersLaBaseArchivMh
        coreDataMonument.region = monument.region?.joined(separator: ",")
        coreDataMonument.statutJuridiqueDeLEdifice = monument.statutJuridiqueDeLEdifice
        coreDataMonument.titreEditorialDeLaNotice = monument.titreEditorialDeLaNotice
        if let lon = monument.coordonneesAuFormatWgs84?.lon,
           let lat = monument.coordonneesAuFormatWgs84?.lat {
            coreDataMonument.lon = lon
            coreDataMonument.lat = lat
        }
        do {
            try coreDataStack.viewContext.save()
        } catch {
            throw CoreDataError.saveFailed
        }
        refresh()
    }

    // MARK: Check existing monument with reference id
    func checkIfItemExist(reference: String) -> Bool {
        request.predicate = NSPredicate(format: "reference == %@", reference)
        guard let count = try? coreDataStack.viewContext.count(for: request) else {
            return false
        }
        return count > 0
    }

    // MARK: Delete one monument
    func deleteOneFavMonument(reference: String) throws {
        request.predicate = NSPredicate(format: "reference == %@", reference)
        if let favoriteMonuments = try? coreDataStack.viewContext.fetch(request) {
            for monument in favoriteMonuments {
                coreDataStack.viewContext.delete(monument)
            }
        }
        do {
            try coreDataStack.viewContext.save()
            refresh()
        } catch {
            throw CoreDataError.deleteFailed
        }
        refresh()
    }
    // MARK: Delete all monuments
    func deleteAllFavMonuments() throws {
        request.predicate = NSPredicate(value: true)
        if let favoriteMonuments = try? coreDataStack.viewContext.fetch(request) {
            for monument in favoriteMonuments {
                coreDataStack.viewContext.delete(monument)
            }
        }
        do {
            try coreDataStack.viewContext.save()
            refresh()
        } catch {
            throw CoreDataError.deleteFailed
        }
    }

    // MARK: - Helper Methods
//    Convert CoreDataMonument to Monument
    private func convertCoreDataMonumentToMonument(_ coreDataMonument: CoreDataMonument?) -> Landmark? {
        guard let coreDataMonument = coreDataMonument else {
            return nil
        }

        return Landmark(reference: coreDataMonument.reference ?? "",
                        datationDeLEdifice: coreDataMonument.datationDeLEdifice ?? "",
                        denominationDeLEdifice: coreDataMonument.denominationDeLEdifice ?? "",
                        descriptionDeLEdifice: coreDataMonument.descriptionDeLEdifice ?? "",
                        historique: coreDataMonument.historique ?? "", lienVersLaBaseArchivMh: coreDataMonument.lienVersLaBaseArchivMh ?? "",
                        region: [coreDataMonument.region ?? ""],
                        departementEnLettres: [coreDataMonument.departementEnLettres ?? ""],
                        formatAbregeDuSiecleDeConstruction: coreDataMonument.formatAbregeDuSiecleDeConstruction ?? "",
                        statutJuridiqueDeLEdifice: coreDataMonument.statutJuridiqueDeLEdifice ?? "",
                        titreEditorialDeLaNotice: coreDataMonument.titreEditorialDeLaNotice ?? "",
                        adresseFormeEditoriale: coreDataMonument.adresseFormeEditoriale ?? "",
                        communeFormeEditoriale: coreDataMonument.communeFormeEditoriale ?? "",
                        coordonneesAuFormatWgs84: CoordonneesWgs84(lon: coreDataMonument.lon, lat: coreDataMonument.lat)
        )
        }
    }
// MARK: - CoreDataError
enum CoreDataError: Error {
    case invalidMonument
    case saveFailed
    case deleteFailed
    var localizedDescription: String {
        switch self {
        case.invalidMonument:
            return "Monument already exist"
        case.saveFailed:
            return "We were unable to save the monument."
        case.deleteFailed:
            return "We were unable to delete the monument."
        }
    }
}

