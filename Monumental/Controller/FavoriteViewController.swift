//
//  FavoriteViewController.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 25/01/2024.
//

import UIKit

class FavoriteViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Properties
    var favMonuments: [Landmark]? = []
    let cellIdentifier = "FavMonumentCell"
    var selectedRow = 0
    private let segueIdentifier = "favToDetails"
    private let coreDataModel = CoreDataManager()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        checkFavMonument()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        checkFavMonument()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier,
            let detailVC =  segue.destination as? MonumentDetailsViewController,
            let selectedLandmark = favMonuments?[selectedRow] {
                detailVC.selectedLandmark = selectedLandmark
        }
    }
    // MARK: - Methods
    func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    func checkFavMonument() {
        let fetchedMonuments = coreDataModel.fetchFavMonuments()
        if !fetchedMonuments.isEmpty {
            // Show ListTableView with fav
//            containerView.isHidden = true
            favMonuments = fetchedMonuments
            collectionView.reloadData()
        } else {
            // Show Empty FavoriteViewController
//            containerView.isHidden = false
        }
    }
    
}
// MARK: - CollectionView data source
extension FavoriteViewController: UICollectionViewDataSource {
    // MARK: Number of Sections
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favMonuments?.count ?? 0
    }
    // MARK: Cell for Item At
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let monumentCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MonumentCollectionViewCell
        else {
            print("Erreur: Impossible de créer une cellule MonumentCollectionViewCell")
            return UICollectionViewCell()
        }
        guard let monument = favMonuments?[indexPath.item],
              let denomination = monument.denominationDeLEdifice,
              let adress = monument.adresseFormeEditoriale,
              let commune = monument.communeFormeEditoriale,
              let department = monument.departementEnLettres

        else { return monumentCell }

        let index = "\(indexPath.item + 1)."
        let image = assignImageBasedOnText(monument.denominationDeLEdifice ?? "")
        
        monumentCell.configure(image: image,
                               index: index,
                               denomination: denomination,
                               adress: adress,
                               commune: commune,
                               department: department.joined(separator: ","))

        monumentCell.layer.borderWidth = 1
        monumentCell.layer.borderColor = UIColor.systemBrown.cgColor
        return monumentCell
    }
}
// MARK: - CollectionView delegate
extension FavoriteViewController: UICollectionViewDelegate {
    // MARK: Did Select Row At
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let monuments = favMonuments, indexPath.item < monuments.count else {
            print("Erreur: Monuments nul ou IndexPath '\(indexPath)' hors de la plage")
            return
        }
        self.selectedRow = indexPath.item
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
}
