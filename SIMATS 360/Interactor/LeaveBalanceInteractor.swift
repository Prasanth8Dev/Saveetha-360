//
//  LeaveBalanceInteractor.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 22/10/24.
//

import Foundation
import Combine

protocol LeaveBalanceInteractorProtocol {
    func fetchLeaveBalance(bioId: String, campus: String) -> AnyPublisher<LeaveDetailModel, Error>
}

class LeaveBalanceInteractor: LeaveBalanceInteractorProtocol {
    func fetchLeaveBalance(bioId: String, campus: String) -> AnyPublisher<LeaveDetailModel, Error> {
        guard let url = URL(string: "\(Constants.Base_URL)employee/getLeaveRecords") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        let body: [String: Any] = [
            "bio_id": bioId,
            "campus": campus
        ]
        return APIWrapper.shared.postRequestMethod(url: url, body: body, responseType: LeaveDetailModel.self)
    }
}
