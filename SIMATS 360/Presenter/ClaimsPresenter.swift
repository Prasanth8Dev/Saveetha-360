//
//  ClaimsPresenter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 29/10/24.
//

import Foundation
import Combine

protocol ClaimsPresenterProtocol {
    func applyClaims(bioId: String, campus: String, creditName: String, dutyDate: String, dutyId: String)
}

class ClaimsPresenter: ClaimsPresenterProtocol {
    weak var view: ClaimsViewController?
    var claimsInteractor: ClaimsInteractorProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    func applyClaims(bioId: String, campus: String, creditName: String, dutyDate: String, dutyId: String) {
        claimsInteractor?.applyClaims(bioId: bioId, campus: campus, creditName: creditName, dutyDate: dutyDate, dutyId: dutyId).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let err):
                self.view?.showMessage(err.localizedDescription)
            case .finished:
                break
            }
        }, receiveValue: { response in
            if response.isClaimed {
                self.view?.showMessage(response.message)
            } else {
                self.view?.showMessage(response.message)
            }
        })
        .store(in: &cancellables)
    }
}
