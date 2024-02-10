//
//  MonumentTableViewCell.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 19/01/2024.
//

import UIKit

class MonumentTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var denomination: UILabel!

    // MARK: - Methods
    func configure(index: String, title: String, subtitle: String) {
        position.text = index
        position.accessibilityLabel = "En position numéro \(index)"
        titleLabel.text = title
        titleLabel.accessibilityLabel = "Le titre du monument est \(title)"
        denomination.text = subtitle
        denomination.accessibilityLabel = "Le monument est de type \(subtitle)"
    }
}
