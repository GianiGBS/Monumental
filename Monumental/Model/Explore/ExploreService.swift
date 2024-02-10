//
//  ExploreService.swift
//  Monumental
//
//  Created by Giovanni Gabriel on 23/10/2023.
//

import Foundation
import Alamofire

// MARK: - Explore API
class ExploreService {

    // MARK: - Properties
    private let session: AFSession

    // MARK: - Initialization
    init(session: AFSession = ExploreSession()) {
        self.session = session
    }

    // MARK: - Methods
    func getLandmark(for departements: String, callback: @escaping(Explore?, Error?) -> Void) {
        guard let apiURL = ExploreURL.endpoint(departement: departements) else {
                // Handle the case where the URL is invalid
            callback(nil, ExploreErrors.invalidURL)
                return
            }

        session.request(url: apiURL,
                        method: .get) { (responseData: AFDataResponse<Data>) in
            DispatchQueue.main.async {
                switch responseData.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let recipes = try decoder.decode(Explore.self, from: data)
                        callback(recipes, nil)
                    } catch {
                        print(error.localizedDescription)
                        callback(nil, ExploreErrors.decodingError)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    callback(nil, error)
                }
            }
        }
    }
}

class ExploreSession: AFSession {
    func request(url: URL,
                 method: Alamofire.HTTPMethod,
                 completionHandler: @escaping (Alamofire.AFDataResponse<Data>) -> Void) {
        AF.request(url).responseData { responseData in
            completionHandler(responseData)
        }
    }
}
enum ExploreErrors: Error {
    case invalidURL
    case decodingError
    case server
}
