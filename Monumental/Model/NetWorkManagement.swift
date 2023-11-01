//
//  NetWorkManagement.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 23/10/2023.
//

import Foundation
import Alamofire

// MARK: - View Protocol
protocol ViewDelegate: AnyObject {
    func updateView()
    func toggleActivityIndicator(shown: Bool)
    func presentAlert(title: String, message: String)
}

// MARK: - Protocol
protocol AFSession {
    func request(url: URL,
                 method: HTTPMethod,
                 completionHandler: @escaping (AFDataResponse<Data>) -> Void)
}
