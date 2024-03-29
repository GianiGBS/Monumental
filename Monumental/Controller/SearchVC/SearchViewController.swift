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
    public weak var delegate: MapViewDelegate?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchController()
        setUpTableView()
        restoreCurrentDataSource()
    }

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
        tableView.reloadData()
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
            // Filtered departments with search text
            filteredDepartments = allDepartments.filter {
                $0.code.lowercased().contains(searchText.lowercased()) ||
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }

// MARK: Update AutoCompletion Table
    func updateSearchResultsTableView(with departments: [Department]) {
        // Update search result with filtered department.
        filteredDepartments = departments
        tableView.reloadData()
    }
}

// MARK: - UISearchBar - Delegate
extension SearchViewController: UISearchBarDelegate {

    // MARK: Text begin Editing
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

    }

    // MARK: Search button cliked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let selectedDepartment = searchBar.text else { return }
        // do when department selected
        print("Selected department: \(selectedDepartment)")
        searchBar.resignFirstResponder()

        // Dismiss modal
        dismiss(animated: true, completion: nil)
        }

    // MARK: Cancel button cliked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Reset list if search cancel
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

        cell.textLabel?.text = "\(department.code) - \(department.name)"

        return cell
    }
}

// MARK: - UITableView - Delegate
extension SearchViewController: UITableViewDelegate {

    // MARK: Did select row at
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDepartment = filteredDepartments[indexPath.row]
        print(selectedDepartment)

        // Send selected department to MapView
        delegate?.didRequestLandmarks(department: selectedDepartment.name)
        // dismiss SearchView
        delegate?.dismissViewModal()
    }
}
