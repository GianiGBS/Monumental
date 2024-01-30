//
//  MonumentCollectionViewCell.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 27/01/2024.
//

import UIKit

class MonumentCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var monumentImage: UIImageView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var denominationLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var communeLabel: UILabel!
    @IBOutlet weak var departmentLAbel: UILabel!
    // MARK: - Navigation

    // MARK: - Methods
    func configure(image: UIImage, index: String, denomination: String, adress: String, commune: String, department: String) {
        monumentImage.image = image
        positionLabel.text = index
        positionLabel.accessibilityLabel = "En position numéro \(index)"
        denominationLabel.text = denomination
        denominationLabel.accessibilityLabel = "le monument est \(denomination)"
        adressLabel.text = adress
        adressLabel.accessibilityLabel = "Le monument se situe au \(adress)"
        communeLabel.text = commune
        communeLabel.accessibilityLabel = "Dans la commune du \(commune)"
        departmentLAbel.text = department
        denominationLabel.accessibilityLabel = "Dans le department de \(department)"
        
    }
}
