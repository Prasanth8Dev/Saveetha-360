//
//  DutyInteractor.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 28/10/24.
//

import Foundation
import Combine

protocol DutyInteractorProtocol {
    func fetchDutyData(bioId: String) -> AnyPublisher<DutyDataModel,Error>
    func fetchClaims(bioId: String) -> AnyPublisher<ClaimsDataModel,Error>
}

class DutyInteractor: DutyInteractorProtocol {
    func fetchClaims(bioId: String) -> AnyPublisher<ClaimsDataModel, any Error> {
        guard let url = URL(string: "http://localhost:1312/employee/pendingDutyClaimsCount") else {
            return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
        }
        let param = ["bioId" : bioId]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: ClaimsDataModel.self)
    }
    
    func fetchDutyData(bioId: String) -> AnyPublisher<DutyDataModel,Error> {
        guard let url = URL(string: "http://localhost:1312/employee/pendingDuty") else {
            return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
        }
        let param = ["bioId" : bioId]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: DutyDataModel.self)
    }
}
