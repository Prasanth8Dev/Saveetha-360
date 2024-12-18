//
//  DutyRosterInteractor.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 13/11/24.
//

import Foundation
import Combine

protocol DutyRosterInteractorProtocol {
    func fetchDutyRoster(fromDate: String, toDate: String, campus: String,bioId: String) -> AnyPublisher<DutyRosterModel,Error>
}

class DutyRosterInteractor: DutyRosterInteractorProtocol {
    func fetchDutyRoster(fromDate: String, toDate: String, campus: String, bioId: String) -> AnyPublisher<DutyRosterModel, any Error> {
        guard let url = URL(string: "\(Constants.Base_URL)employee/dutyRoster") else {
            return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
        }
        let param = ["requestFrom": fromDate, "requestTo": toDate, "bioId":bioId, "campus":campus]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: DutyRosterModel.self)
    } 
}
