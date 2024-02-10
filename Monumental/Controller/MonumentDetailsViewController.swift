//
//  MonumentDetailsViewController.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 12/12/2023.
//

import UIKit

class MonumentDetailsViewController: UIViewController {

    // MARK: - Outlet

    @IBOutlet weak var monumImage: UIImageView!
// Group Top
    @IBOutlet weak var favButton: UIButton!
// Type
    @IBOutlet weak var monumName: UILabel!
// Group 1
    @IBOutlet weak var monumReference: UILabel!
    @IBOutlet weak var monumStatus: UILabel!
// Title
    @IBOutlet weak var monumTitle: UILabel!
// Group 2
    @IBOutlet weak var monumDatation: UILabel!
    @IBOutlet weak var monumSiecle: UILabel!
// Group 3
    @IBOutlet weak var monumDescription: UILabel!
    @IBOutlet weak var monumHistory: UILabel!
// Group 4
    @IBOutlet weak var monumAdress: UILabel!
    @IBOutlet weak var monumLocation: UILabel!
// Group Bottom
    @IBOutlet weak var monumDepartment: UILabel!

    // MARK: - Properties
    var selectedLandmark: Landmark?
    private let segueIdentifier = "detailsToMap"
    private let coreDataModel = CoreDataManager()
    public weak var delegate: MapViewDelegate?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView(monument: selectedLandmark)
        // Do any additional setup after loading the view.
    }

    // MARK: - Actions
    @IBAction func favButtonTapped( sender: UIButton) {
        save(monument: selectedLandmark)
    }
    @IBAction func getEtudeTapped( sender: Any) {
        guard let landmark = selectedLandmark,
              let linkToEtude = landmark.lienVersLaBaseArchivMh,
              let url = URL(string: linkToEtude)
        else {
            presentAlert(title: "Error", message: "Invalide recipe URL.")
            return
        }
        UIApplication.shared.open(url)
    }
    @IBAction func showDirections() {
        guard let landmark = selectedLandmark else {
                return
            }
            delegate?.showDirections(for: landmark)
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }

    // MARK: - Methods
    /// Update View with monument's details
    func updateView(monument: Landmark?) {
        guard let monument =  monument,
        let reference = monument.reference else {
            print("L'objet Monument est nul.")
            return
        }
        // Head
        monumImage.image = assignImageBasedOnText(monument.denominationDeLEdifice ?? "")
        if coreDataModel.checkIfItemExist(reference: reference) {
            favButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            favButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        // Type
        monumName.text = monument.denominationDeLEdifice ?? "Non renseigné"
        // Groupe 1
        monumReference.text = monument.reference ?? "Non renseigné"
        monumStatus.text = monument.statutJuridiqueDeLEdifice ?? "Non renseigné"
        // Titre
        monumTitle.text = monument.titreEditorialDeLaNotice ?? "Non renseigné"
        // Groupe 2
        monumDatation.text = monument.datationDeLEdifice ?? "Non renseigné"
        monumSiecle.text = monument.formatAbregeDuSiecleDeConstruction ?? "Non renseigné"
        // Greoupe 3
        monumDescription.text = monument.descriptionDeLEdifice ?? "Description non renseigné"
        monumHistory.text = monument.historique ?? "Historique non renseigné"
        // Greoupe 4
        monumAdress.text = monument.adresseFormeEditoriale ?? "Adresse non renseigné"
        monumLocation.text = monument.communeFormeEditoriale ?? "Non renseigné"
        // End
        monumDepartment.text = monument.departementEnLettres?.first ?? "Non renseigné"
        }
    /// Checking fav button
    func checkFavButton() {
        if let monumentReference = selectedLandmark?.reference,
            coreDataModel.checkIfItemExist(reference: monumentReference) {
            favButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            favButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    /// Save monument in CoreData
    private func save(monument: Landmark?) {
        if let monumentReference = selectedLandmark?.reference, let  monument = selectedLandmark {
            if coreDataModel.checkIfItemExist(reference: monumentReference) {
                do {
                    try coreDataModel.deleteOneFavMonument(reference: monumentReference)
                    favButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
                } catch {
                    print(error)
                }
                print("Monument Deleted")
            } else {
                do {
                    try coreDataModel.addMonumentToFav(monument: monument)
                    favButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                } catch {
                    print(error.localizedDescription)
                }
                print("Monument Saved")
            }
        }
    }
    func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
