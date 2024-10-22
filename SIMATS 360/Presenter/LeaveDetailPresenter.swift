//
//  LeaveDetailPresenter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 22/10/24.
//

import Foundation
import Combine

protocol LeaveDetailPresenterProtocol: AnyObject {
    func fecthLeaveDetails(bioId: String, campus:String)
}

class LeaveDetailPresenter: LeaveDetailPresenterProtocol {
    weak var view: LeaveBalanceViewController?
    
    var leaveBalanceRouter: LeaveBalanceRouter?
    var leaveBalanceInteractor: LeaveBalanceInteractor?
    private var cancelable = Set<AnyCancellable>()
    
    func fecthLeaveDetails(bioId: String, campus: String) {
        leaveBalanceInteractor?.fetchLeaveBalance(bioId: bioId, campus: campus).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let err):
                self.view?.showError(errorMessage: err.localizedDescription)
            }
        }, receiveValue: { response in
            if response.status {
                self.view?.loadLeaveData(response: response)
            } else {
                self.view?.showError(errorMessage: response.message)
            }
        })
        .store(in: &cancelable)
    }
}
