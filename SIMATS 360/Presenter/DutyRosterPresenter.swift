//
//  DutyRosterPresenter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 13/11/24.
//

import Foundation
import Combine

protocol DutyRosterPresenterProtocol {
    func dutyRosterData(fromDate: String, toDate: String, campus: String,bioId: String)
}

class DutyRosterPresenter: DutyRosterPresenterProtocol {
    var dutyRosterView: DutyRosterViewController?
    var interactor: DutyRosterInteractorProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    func dutyRosterData(fromDate: String, toDate: String, campus: String, bioId: String) {
        interactor?.fetchDutyRoster(fromDate: fromDate, toDate: toDate, campus: campus, bioId: bioId).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let err):
                self.dutyRosterView?.showMessage(message: err.localizedDescription)
                
            case .finished:
                break
            }
        }, receiveValue: { response in
            if response.status {
                self.dutyRosterView?.showDutyData(response)
            } else {
                self.dutyRosterView?.showMessage(message: response.message)
            }
        })
        .store(in: &cancellables)
    }
}
