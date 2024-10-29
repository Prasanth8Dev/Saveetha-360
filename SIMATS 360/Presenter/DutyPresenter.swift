//
//  DutyPresenter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 28/10/24.
//

import Foundation
import Combine

protocol DutyPresenterProtocol {
    func fetchPendingDuty(bioId: String)
}

class DutyPresenter: DutyPresenterProtocol {
    
    weak var view: DutyViewController?
    var dutyInteractor: DutyInteractorProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    func fetchPendingDuty(bioId: String) {
        dutyInteractor?.fetchDutyData(bioId: bioId).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let err):
                self.view?.showMessage(Str: err.localizedDescription)
            }
        }, receiveValue: { response in
            if response.status {
                self.view?.showPendingDutyData(response)
            } else {
                self.view?.showMessage(Str: response.message)
            }
        })
        .store(in: &cancellables)
    }
}
