//
//  ExploreManager.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 23/10/2023.
//

import Foundation

// MARK: - Explore API View Delegate
class ExploreManager {

    // MARK: - Properties
    var monuments: [Landmark] = []
    let exploreService = ExploreService()
    public weak var delegate: ViewDelegate?

    // MARK: - Methods
    public func fetchData(for departements: String) {
        self.delegate?.fetchDataInProgress(shown: true)

        exploreService.getLandmark(for: departements) { [weak self] explore, error in
            self?.delegate?.fetchDataInProgress(shown: false)

            DispatchQueue.main.async { [weak self] in
                if let error = error {
                    self?.handleError(error)
                } else if let explore = explore, let landmarks = explore.results {
                    self?.monuments = landmarks
                    self?.delegate?.updateView()
                }
            }
        }
    }
    // MARK: - Private Methods
        private func handleError(_ error: Error) {
            // Handle the error appropriately, e.g., show an alert or log it.
            delegate?.presentAlert(title: "Erreur de chargement",
                                   message: "Une erreur lors du chargement des données. Veuillez réessayer plus tard.")
        }
}
