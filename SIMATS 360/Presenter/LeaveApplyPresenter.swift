//
//  LeaveApplyPresenter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 23/10/24.
//

import Foundation
import Combine

protocol LeaveApplyPresenterProtocol: AnyObject {
    func applyLeave(param:[String:Any])
}

class LeaveApplyPresenter: LeaveApplyPresenterProtocol {
    weak var view: LeaveApplicationViewControllerProtocol?
    var applyLeaveInteractor: LeaveApplyInteractor?
    private var cancellables = Set<AnyCancellable>()
    
    func applyLeave(param:[String:Any]) {
        applyLeaveInteractor?.applyLeave(param: param).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure:
                break
            }
        }, receiveValue: { response in
            if response.status {
                self.view?.showResponse(message: response.message)
            } else {
                self.view?.showResponse(message: response.message)
            }
        })
        .store(in: &cancellables)
    }
}
