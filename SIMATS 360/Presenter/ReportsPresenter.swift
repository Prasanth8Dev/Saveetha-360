//
//  ReportsPresenter.swift
//  Saveetha 360
//
//  Created by Prasanth S on 14/10/24.
//

import Foundation
import Combine

protocol ReportsPresenterProtocol: AnyObject {
    func fetchSalaryReports(bioId: String)
}

class ReportsPresenter: ReportsPresenterProtocol {
    
    weak var view: ReportsViewProtocol?
    var reportsInteractor: SalaryReportInteractorProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    func fetchSalaryReports(bioId: String) {
        reportsInteractor?.fetchSalaryReports(bioId: bioId).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let err):
                print(err.localizedDescription)
                self.view?.showError(err.localizedDescription)
            case .finished:
                break
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
