//
//  ContentTableViewController.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 15/01/2024.
//

import UIKit

class ContentTableViewController: UITableViewController {
    
    // MARK: - Outlets
    

    // MARK: - Properties
    var monuments: [Landmark]? = []
    let cellIdentifier = "MonumentCell"
    var selectedRow = 0
    private let segueIdentifier = "tableViewToDetails"

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier, 
            let detailVC =  segue.destination as? MonumentDetailsViewController,
            let selectedLandmark = monuments?[selectedRow] {
                detailVC.selectedLandmark = selectedLandmark
        }
    }
    // MARK: - Methods
    // MARK: - TableView data source
    // MARK: Number of Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }
    // MARK: Number of Rows in Sections
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return monuments?.count ?? 0
    }
    // MARK: Cell for Row At
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let monumentCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MonumentTableViewCell
        else { 
            print("Erreur: Impossible de créer une cellule MonumentTableViewCell")
            return UITableViewCell()
        }
        guard let monument = monuments?[indexPath.row],
              let title = monument.titreEditorialDeLaNotice,
              let subtitle = monument.denominationDeLEdifice
        else {return monumentCell}
        
        let index = "\(indexPath.row + 1)."

        // Configuration of monumentCell
        monumentCell.configure(index: index, 
                               title: title,
                               subtitle: subtitle)

        return monumentCell
    }
    // MARK: - TableView Delegate
    // MARK: Did Select Row At
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let monuments = monuments, indexPath.row < monuments.count else {
            print("Erreur: Monuments nul ou IndexPath '\(indexPath)' hors de la plage")
            return
        }
        self.selectedRow = indexPath.row
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
}
