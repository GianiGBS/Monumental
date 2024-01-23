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
    @IBOutlet weak var monumName: UILabel!

    @IBOutlet weak var monumReference: UILabel!
    @IBOutlet weak var monumStatus: UILabel!

    @IBOutlet weak var monumTitle: UILabel!

    @IBOutlet weak var monumDatation: UILabel!
    @IBOutlet weak var monumSiecle: UILabel!

    @IBOutlet weak var monumDescription: UILabel!
    @IBOutlet weak var monumHistory: UILabel!

    @IBOutlet weak var monumAdress: UILabel!
    @IBOutlet weak var monumLocation: UILabel!

    @IBOutlet weak var monumDepartment: UILabel!

    // MARK: - Properties
    var selectedLandmark: Landmark?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView(monument: selectedLandmark)
        // Do any additional setup after loading the view.
    }

    // MARK: - Actions

    // MARK: - Methods
    func assignImageBasedOnText(_ text: String) -> UIImage {
        let specificWords = ["café", "contrefort", "église", "fontaine", "hospice", "immeuble", "maison", "parc", "pont", "presbytère"]
        let defaultImageName = "ruine"

        guard let specificWord = specificWords.first(where: { text.lowercased().contains($0.lowercased()) }),
           let specificImage = UIImage(named: specificWord) else {
            return UIImage(named: defaultImageName) ?? UIImage()
        }
            return specificImage
        }

    func updateView(monument: Landmark?) {
        guard let monument =  monument else {
            print("L'objet Monument est nul.")
            return
        }
        // Head
        monumImage.image = assignImageBasedOnText(monument.denominationDeLEdifice ?? "")
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
        
}
