//
//  ClaimsInteractor.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 29/10/24.
//

import Foundation
import Combine

protocol ClaimsInteractorProtocol {
    func applyClaims(bioId: String, campus: String, creditName: String, dutyDate: String, dutyId: String) -> AnyPublisher<ClaimsResponseModel, Error>
}

class ClaimsInteractor: ClaimsInteractorProtocol {
    func applyClaims(bioId: String, campus: String, creditName: String, dutyDate: String, dutyId: String) -> AnyPublisher<ClaimsResponseModel, Error> {
        guard let url = URL(string: "\(Constants.Base_URL)employee/dutyClaims") else {
            return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
        }
        let param = ["bioId" : bioId,"campus":campus,"creditName":creditName,"dutyDate":dutyDate, "dutyId":dutyId]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: ClaimsResponseModel.self)
    }
}
