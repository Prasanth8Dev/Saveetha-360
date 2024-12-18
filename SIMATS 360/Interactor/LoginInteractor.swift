//
//  LoginInteractor.swift
//  Saveetha 360
//
//  Created by Prasanth S on 14/10/24.
//


import Combine
import Foundation

protocol LoginInteractorProtocol {
    func login(email: String, password: String) -> AnyPublisher<LoginResponse, Error>
}

class LoginInteractor: LoginInteractorProtocol {
    func login(email: String, password: String) -> AnyPublisher<LoginResponse, Error> {
        guard let url = URL(string: "\(Constants.Base_URL)employee/login") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        let body: [String: Any] = [
            "bioId": email,
            "password": password
        ]

        // Use the APIWrapper to perform the login API call
        return APIWrapper.shared.postRequestMethod(url: url, body: body, responseType: LoginResponse.self)
            .eraseToAnyPublisher()
    }
}
