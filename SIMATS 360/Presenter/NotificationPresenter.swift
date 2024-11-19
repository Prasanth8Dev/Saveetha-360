//
//  NotificationPresenter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 25/10/24.
//

import Foundation
import Combine

protocol NotificationPresenterProtocol {
    func fetchGeneralNotification(campus: String,completionHandler: @escaping()->Void)
    func fetchApprovalNotification(bioId: String, campus: String,completionHandler: @escaping()->Void)
    func fetchSwapNotifications(bioId: String, campus: String,completionHandler: @escaping()->Void)
}

class NotificationPresenter: NotificationPresenterProtocol {
    weak var notificationView: NotificationViewController?
    
    var notificationInteractor: NotificationInteractorProtocol?
    private var cancalable = Set<AnyCancellable>()
    
    
    func fetchGeneralNotification(campus: String,completionHandler: @escaping () -> Void) {
        notificationInteractor?.fetchGeneralNotification(campus: campus).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let err):
                self.notificationView?.showAlert(message: err.localizedDescription)
                completionHandler()
            }
        }, receiveValue: { response in
            self.notificationView?.showGeneralNotification(data: response)
            completionHandler()
        })
        .store(in: &cancalable)
    }
    
    func fetchApprovalNotification(bioId: String, campus: String,completionHandler: @escaping () -> Void) {
        notificationInteractor?.fetchApprovalNotification(bioId: bioId, campus: campus).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let err):
                self.notificationView?.showAlert(message: err.localizedDescription)
                completionHandler()
            }
        }, receiveValue: { response in
            self.notificationView?.showApprovalNotification(data: response)
            completionHandler()
        })
        .store(in: &cancalable)
    }
    
    func fetchSwapNotifications(bioId: String, campus: String, completionHandler: @escaping () -> Void) {
        notificationInteractor?.fetchSwapNotifications(bioId: bioId, campus: campus).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let err):
                self.notificationView?.showAlert(message: err.localizedDescription)
                completionHandler()
            case .finished:
                break
            }
        }, receiveValue: { response in
            if response.status {
                self.notificationView?.showSwapNotification(data: response)
            } else {
                self.notificationView?.showAlert(message: response.message)
            }
            completionHandler()
        })
        .store(in: &cancalable)
    }
}
