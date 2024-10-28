//
//  NotificationInteractor.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 25/10/24.
//

import Foundation
import Combine

protocol NotificationInteractorProtocol: AnyObject {
    func fetchGeneralNotification() -> AnyPublisher<NotificationModel, Error>
    func fetchApprovalNotification(bioId: String, campus: String) -> AnyPublisher<ApprovalNotificationModel, Error>
}

class NotificationInteractor: NotificationInteractorProtocol {
    
    func fetchGeneralNotification()  -> AnyPublisher<NotificationModel, Error> {
        guard let url = URL(string: "http://localhost:1312/employee/generalNotification") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return APIWrapper.shared.getRequestMethod(url: url, responseType: NotificationModel.self)
    }
    
    func fetchApprovalNotification(bioId: String,campus: String)  -> AnyPublisher<ApprovalNotificationModel, Error> {
        guard let url = URL(string: "http://localhost:1312/employee/approvalNotification") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let param = ["bioId" : bioId,
                     "campus": campus]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: ApprovalNotificationModel.self)
    }
}
