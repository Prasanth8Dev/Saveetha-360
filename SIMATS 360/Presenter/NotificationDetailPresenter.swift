//
//  NotificationDetailPresenter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 13/11/24.
//

import Foundation
import Combine

protocol NotificationDetailPresenterProtocol {
    func updateLeaveRequest(leaveId: String, status: String)
    func updateSwapRequest(swapId: String, status: String)
}

class NotificationDetailPresenter: NotificationDetailPresenterProtocol {
   
    
    var view: NotificationDetailViewControllerProtocol?
    var interactor: NotificationDetailsInteractor?
    private var cancellables = Set<AnyCancellable>()
    
    func updateLeaveRequest(leaveId: String, status: String) {
        interactor?.updateLeaveRequest(leaveId: leaveId, status: status).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let err):
                self.view?.showMessage(message: err.localizedDescription)
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
    
    func updateSwapRequest(swapId: String, status: String) {
        interactor?.updateSwapRequest(swapId: swapId, status: status).sink(receiveCompletion: { completion in
            switch completion {
                case .finished:
                break
            case .failure(let err):
                self.view?.showMessage(message: err.localizedDescription)
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
}
