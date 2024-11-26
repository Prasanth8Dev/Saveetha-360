//
//  GeneralSwapDutyPresenter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 23/11/24.
//

import Foundation
import Combine

protocol GeneralSwapDutyPresenterProtocol {
    func fetchGroupOptions(bioId: String,campus:String)
}

class GeneralSwapDutyPresenter: GeneralSwapDutyPresenterProtocol {
    var view: GeneralSwapDutyViewController?
    var interactor: GeneralSwapDutyInteractorProtocol?
    var router: GeneralSwapDutyRouterProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    func fetchGroupOptions(bioId: String,campus:String) {
        interactor?.fetchGroupOptions(bioId: bioId,campus:campus).sink(receiveCompletion: { completion in
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
