//
//  SalaryDetailsPresenter.swift
//  Saveetha 360
//
//  Created by Prasanth S on 18/10/24.
//

import Foundation
import Combine

protocol SalaryDetailsPresenterProtocol: AnyObject {
    func fetchSalaryDetails(bioId: String)
}

class SalaryDetailsPresenter: SalaryDetailsPresenterProtocol {
    weak var view: SalaryDetailsProtocol?
    var salaryDetailsInteractor: SalaryDetailsInteractorProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    func fetchSalaryDetails(bioId: String) {
        salaryDetailsInteractor?.fetchSalaryDetails(bioId: bioId).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let err):
                self.view?.showError(err.localizedDescription)
            }
        }, receiveValue: { response in
            if response.status {
                self.view?.displaySalaryReports(response)
            } else {
                self.view?.showError(response.message)
            }
        })
        .store(in: &cancellables)
    }
}
