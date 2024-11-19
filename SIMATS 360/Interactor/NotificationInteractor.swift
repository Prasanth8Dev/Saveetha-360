//
//  NotificationInteractor.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 25/10/24.
//

import Foundation
import Combine

protocol NotificationInteractorProtocol: AnyObject {
    func fetchGeneralNotification(campus: String) -> AnyPublisher<NotificationModel, Error>
    func fetchApprovalNotification(bioId: String, campus: String) -> AnyPublisher<ApprovalNotificationModel, Error>
    func fetchSwapNotifications(bioId: String, campus: String) -> AnyPublisher<SwapDutyDataResponse, Error>
}

class NotificationInteractor: NotificationInteractorProtocol {
    
    
    
    func fetchGeneralNotification(campus: String)  -> AnyPublisher<NotificationModel, Error> {
        guard let url = URL(string: "http://localhost:1312/employee/generalNotification") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let param = ["campus": campus]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: NotificationModel.self)
    }
    
    func fetchApprovalNotification(bioId: String,campus: String)  -> AnyPublisher<ApprovalNotificationModel, Error> {
        guard let url = URL(string: "http://localhost:1312/employee/approvalNotification") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let param = ["bioId" : bioId,
                     "campus": campus]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: ApprovalNotificationModel.self)
    }
    
    func fetchSwapNotifications(bioId: String, campus: String) -> AnyPublisher<SwapDutyDataResponse, any Error> {
        guard let url = URL(string: "http://localhost:1312/employee/swapDutyNotification") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let param = ["bioId" : bioId,
                     "campus": campus]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: SwapDutyDataResponse.self)
    }
}
