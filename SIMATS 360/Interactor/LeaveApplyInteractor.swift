//
//  LeaveApplyInteractor.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 23/10/24.
//

import Foundation
import Combine

protocol LeaveApplyInteractorProtocol: AnyObject {
    func applyLeave(param:[String:Any]) ->AnyPublisher<ApplyLeaveModel, Error>
}

class LeaveApplyInteractor: LeaveApplyInteractorProtocol {
    func applyLeave(param:[String:Any]) -> AnyPublisher<ApplyLeaveModel, Error> {
        guard let url = URL(string: "\(Constants.Base_URL)employee/applyLeave") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return  APIWrapper.shared.postMultipartFormData(url: url, parameters: param, responseType: ApplyLeaveModel.self)
    }
}
