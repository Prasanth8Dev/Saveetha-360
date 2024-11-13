//
//  NotificationDetailsInteractor.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 13/11/24.
//

import Foundation
import Combine

protocol NotificationDetailsInteractorProtocol {
    func updateLeaveRequest(leaveId: String, status: String)-> AnyPublisher<LeaveUpdateModel,Error>
}

class NotificationDetailsInteractor: NotificationDetailsInteractorProtocol {
    func updateLeaveRequest(leaveId: String, status: String) -> AnyPublisher<LeaveUpdateModel, any Error> {
        guard let url = URL(string: "http://localhost:1312/employee/leaveApproval") else {
            return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
        }
        let param = ["leaveId": leaveId, "status": status]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: LeaveUpdateModel.self)
    }
    
    
}
