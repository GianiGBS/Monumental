//
//  SearchViewController.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 11/10/2023.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    // MARK: - Properties
    var searchController = UISearchController()
    let allDepartments = DepartmentManager.departments
    var filteredDepartments: [Department] = []  // Liste des départements filtrée
    let cellIndentifier = "DepartementCell"
    private let landmarkModel = ExploreManager()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchController()
        setUpTableView()
        restoreCurrentDataSource()
        setUpDelegateModel()
    }
    // MARK: - Actions

    // MARK: - Methods
    func setUpSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Entrez un département"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIndentifier)
    }
    func restoreCurrentDataSource() {
        filteredDepartments = allDepartments
        tableView.reloadData() // mise à jour de la table view
    }
    func setUpDelegateModel() {
        landmarkModel.delegate = self
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
// MARK: AutoComplesion
    func updateSearchResults(for searchController: UISearchController) {
        // searchBar press
        guard let searchText = searchController.searchBar.text else {
            return
        }
        if searchText.isEmpty {
            filteredDepartments = allDepartments
        } else {
            // Filtrer les départements en fonction du texte de la recherche
            filteredDepartments = allDepartments.filter {
                $0.code.lowercased().contains(searchText.lowercased()) ||
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
//        updateSearchResultsTableView(with: filteredDepartments)
    }
// MARK: Update AutoCompletion Table
    func updateSearchResultsTableView(with departments: [Department]) {
        // Mise à jour des résultats de recherche avec les départements filtrés.
        filteredDepartments = departments
        tableView.reloadData() // mise à jour de la table view
    }
}
// MARK: - UISearchBar - Delegate
extension SearchViewController: UISearchBarDelegate {
    // MARK: Text begin Editing
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

        // Présentez votre SearchResultsViewController
//        presentSearchResultsController()
    }
    // MARK: Search button cliked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let selectedDepartment = searchBar.text else { return }
        // Effectuez l'action avec le département sélectionné
        print("Selected department: \(selectedDepartment)")
        searchBar.resignFirstResponder()

        // Dismiss modal
        dismiss(animated: true, completion: nil)
        }
    // MARK: Cancel button cliked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Réinitialiser la liste des départements lorsque l'annulation de la recherche
        filteredDepartments = allDepartments
        updateSearchResultsTableView(with: filteredDepartments)
        print("Dismiss")
        // Dismiss modal
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - UITableView - DataSource
extension SearchViewController: UITableViewDataSource {
    // MARK: Number of Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // MARK: Number of Rows in Sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredDepartments.count
    }
    // MARK: Cell for Row At
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
}
// MARK: - UITableView - Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDepartment = filteredDepartments[indexPath.row]
//        Remplir le champ de texte de recherche avec le nom de l'élément sélectionné
//            searchController.searchBar.text = selectedDepartment.name
//        Fetch les données pour le département
        landmarkModel.fetchData(for: selectedDepartment.name)
        print(selectedDepartment)
//        Reduire la vue modal (SearchViewController)
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - ExploreManager - ViewDelegate
extension SearchViewController: ViewDelegate {
    func updateView() {
        print(landmarkModel.monuments)
        //        Reduire le floatingPanel de la MapView
                if let mapViewController = parent as? MapViewController {
                    mapViewController.landmarks = landmarkModel.monuments
                    mapViewController.addLandmarkMarkers()
                    mapViewController.floatingPanelController.dismiss(animated: true, completion: {
                    })
                }
    }
    func toggleActivityIndicator(shown: Bool) {
    }
    func presentAlert(title: String, message: String) {
    }
}