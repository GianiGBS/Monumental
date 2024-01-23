//
//  SearchResultsViewController.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 01/12/2023.
//

import UIKit

class SearchResultsViewController: UITableViewController {

    // MARK: - Outlets
    // MARK: - Properties
    var filteredDepartments: [Department] = []  // Liste des départements filtrée
    let cellIndentifier = "DepartementCell"
    private let landmarkModel = ExploreManager()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpDelegateModel()
    }
    // MARK: - Actions
    // MARK: - Methods
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIndentifier)
    }
    func setUpDelegateModel() {
        landmarkModel.delegate = self
    }
    // MARK: - UITableView - DataSource
    // MARK: Number of Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // MARK: Number of Rows in Sections
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredDepartments.count
    }
    // MARK: Cell for Row At
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIndentifier,
            for: indexPath)

        let department = filteredDepartments[indexPath.row]

//        cell.contentConfiguration = UIListContentConfiguration.cell()
//        var content = cell.defaultContentConfiguration()
//        cell.contentConfiguration = content
//        content.text = "\(department.code) - \(department.name)"

        cell.textLabel?.text = "\(department.code) - \(department.name)"

        return cell
    }
    // MARK: - UITableView - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDepartment = filteredDepartments[indexPath.row]

//        Remplir le champ de texte de recherche avec le nom de l'élément sélectionné
        if let searchController = parent?.navigationItem.searchController {
            searchController.searchBar.text = selectedDepartment.name
        }
//        Fetch les données pour le département
        landmarkModel.fetchData(for: selectedDepartment.name)

//        Reduire la vue modal (SearchViewController)
        parent?.dismiss(animated: true, completion: nil)

//        Reduire le floatingPanel de la MapView
//        if let mapViewController = parent as? MapViewController {
//            mapViewController.landmarks = landmarkModel.monuments
//            mapViewController.floatingPanelController.dismiss(animated: true, completion: {
//                mapViewController.addLandmarkMarkers()
//            })
//        }
    }
}
// MARK: - ViewDelegate
extension SearchResultsViewController: ViewDelegate {
    func updateView() {
        print(landmarkModel.monuments)
    }
    func toggleActivityIndicator(shown: Bool) {
    }
    func presentAlert(title: String, message: String) {
    }
}
