//
//  ProfilePresenter.swift
//  Saveetha 360
//
//  Created by Prasanth S on 17/10/24.
//

import Foundation
import Combine

protocol ProfilePresenterProtocol {
    func fetchProfile(bioId: String, campus: String)
}

class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewProtocol?
    var profileInteractor: ProfileInteractorProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    func fetchProfile(bioId: String, campus: String) {
        profileInteractor?.fetchProfile(bioId: bioId, campus: campus).sink(receiveCompletion: { comletion in
            switch comletion {
            case .finished:
                break
            case .failure(let err):
                self.view?.showError(err.localizedDescription)
            }
        }, receiveValue: { response in
            self.view?.displayProfileData(response)
        })
        .store(in: &cancellables)
    }
    
    
}
