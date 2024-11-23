//
//  LoginPresenter.swift
//  Saveetha 360
//
//  Created by Prasanth S on 14/10/24.
//

import Foundation
import Combine

protocol LoginPresenterProtocol {
    func login(email: String, password: String)
}

class LoginPresenter: LoginPresenterProtocol {
    weak var view: LoginViewProtocol?
    var interactor: LoginInteractorProtocol?
    var router: LoginRouterProtocol?
    private var cancellables = Set<AnyCancellable>()

    func login(email: String, password: String) {
        interactor?.login(email: email, password: password)
            .sink(receiveCompletion: { completion in
                self.view?.stopLoader()
                switch completion {
                case .failure(let error):
                    print("Login failed with error: \(error)")
                    self.view?.displayLoginResult(error.localizedDescription)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                if response.status ?? false {
                    //self?.view?.displayLoginResult("Login Successful!")
                    Constants.profileData = response
                    self?.router?.navigateToHome(from: self?.view ?? LoginViewController(), successResponse: response)
                } else if let message = response.message  {
                    self?.view?.displayLoginResult(message)
                }
            })
            .store(in: &cancellables)
    }
}
