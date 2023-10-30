//
//  NetWorkManagement.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 23/10/2023.
//

import Foundation

// MARK: - View Protocol
protocol ViewDelegate: AnyObject {
    func updateView()
    func toggleActivityIndicator(shown: Bool)
    func presentAlert(title: String, message: String)
}
