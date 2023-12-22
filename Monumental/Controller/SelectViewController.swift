//
//  SelectViewController.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 28/11/2023.
//

import UIKit

class SelectViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var myTableview: UITableView!

    // MARK: - Properties
    let modalStoryboardID = "searchFloatingPanel"
    let data = DepartmentManager.departments

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        setUpTableView()

    }
    // MARK: - Methods
    func setUpSearchBar() {
        searchBar.delegate =  self

    }
    func setUpTableView() {
        myTableview.delegate = self
        myTableview.dataSource = self
        myTableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    // MARK: Modal SearchView
    func presentSearchModal() {
            guard let searchViewController = storyboard?.instantiateViewController(withIdentifier: modalStoryboardID)
                    as? SearchViewController else {
                return
            }
            let navigationController = UINavigationController(rootViewController: searchViewController)

            // modal style
        navigationController.modalPresentationStyle = .overCurrentContext
        // TODO: 
            present(navigationController, animated: true, completion: nil)
        }
}
// MARK: - UISearchBar - Delegate
extension SelectViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // Show modal view when touched
        presentSearchModal()
        // Don't show keyboard
        return false
    }
}
// MARK: - UITableView - DataSource
extension SelectViewController: UITableViewDataSource {
    // MARK: Number of Rows in Sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    // MARK: Cell for Row At
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let department = data[indexPath.row]
        cell.textLabel?.text = "\(department.code) - \(department.name)"
        return cell
    }

    // MARK: Number of Sections
}
// MARK: - UITableView Delegate
extension SelectViewController: UITableViewDelegate {
}
