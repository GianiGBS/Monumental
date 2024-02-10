//
//  NetWorkManagement.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 23/10/2023.
//

import Foundation
import Alamofire
import UIKit

// MARK: - View Protocol
protocol ViewDelegate: AnyObject {
    func updateView()
    func fetchDataInProgress(shown: Bool)
    func presentAlert(title: String, message: String)
}
protocol MapViewDelegate: AnyObject {
    func didRequestLandmarks(department: String?)
    func showDirections(for landmark: Landmark?)
    func dismissViewModal()
}
protocol CorelocationServiceDelegate: AnyObject {
    func didUpdateLocation(departement: String?)
}
// MARK: - Protocol
protocol AFSession {
    func request(url: URL,
                 method: HTTPMethod,
                 completionHandler: @escaping (AFDataResponse<Data>) -> Void)
}
// MARK: - Function
/// Update View with monument's image
func assignImageBasedOnText(_ text: String) -> UIImage {
    let specificWords = ["café", "contrefort",
                         "église", "fontaine",
                         "hospice", "immeuble",
                         "maison", "parc",
                         "pont", "presbytère"]
    let defaultImageName = "ruine"

    guard let specificWord = specificWords.first(where: { text.lowercased().contains($0.lowercased()) }),
       let specificImage = UIImage(named: specificWord) else {
        return UIImage(named: defaultImageName) ?? UIImage()
    }
        return specificImage
    }
