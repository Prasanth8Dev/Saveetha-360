//
//  SwapDutyPresenter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 11/11/24.
//

import Foundation
import Combine

protocol SwapDutyPresenterProtocol {
    func swapDutyRequest(reqFromId: String,reqToId: String, dutyId: String)
    func fetchSwapStatus(bioId: String)
}

class SwapDutyPresenter: SwapDutyPresenterProtocol {

    weak var view: SwapDutyViewController?
    var swapInteractor: SwapDutyInteractorProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    func swapDutyRequest(reqFromId: String, reqToId: String, dutyId: String) {
        swapInteractor?.requestSwapDuty(reqFromId: reqFromId, reqToId: reqToId, dutyId: dutyId).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let err):
                self.view?.showMessage(message: err.localizedDescription)
            case .finished:
                break
            }
        }, receiveValue: { response in
            if response.status {
                self.view?.showMessage(message: response.message)
            } else {
                self.view?.showMessage(message: response.message)
            }
        })
        .store(in: &cancellables)
    }
    
    func fetchSwapStatus(bioId: String) {
        swapInteractor?.fetchSwapStatus(bioId: bioId).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let err):
                self.view?.showMessage(message: err.localizedDescription)
            case .finished:
                break
            }
        }, receiveValue: { response in
            if response.status {
                self.view?.showStatus(response)
            } else {
                self.view?.showMessage(message: response.message)
            }
        })
        .store(in: &cancellables)
    }
    
}
