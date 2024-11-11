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
    func fetchClaims(bioId: String)
    func fetchGroupOptions(bioId: String,campus:String)
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
    
    func fetchClaims(bioId: String) {
        dutyInteractor?.fetchClaims(bioId: bioId).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let err):
                self.view?.showMessage(Str: err.localizedDescription)
            case .finished:
                break
            }
        }, receiveValue: { response in
            if response.status {
                self.view?.showClaimsData(response)
            } else {
                self.view?.showMessage(Str: response.message)
            }
        })
        .store(in: &cancellables)
    }
    
    func fetchGroupOptions(bioId: String, campus: String) {
        dutyInteractor?.fetchGroupData(bioId: bioId, campus: campus).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let err):
                self.view?.showMessage(Str: err.localizedDescription)
            case .finished:
                break
                
            }
        }, receiveValue: { response in
            if response.status {
                self.view?.getGropuData(response)
            } else {
                self.view?.showMessage(Str: response.message)
            }
        })
        .store(in: &cancellables)
    }
}
