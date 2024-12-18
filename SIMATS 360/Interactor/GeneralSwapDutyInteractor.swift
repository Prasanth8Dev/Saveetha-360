//
//  GeneralSwapDutyInteractor.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 23/11/24.
//

import Foundation
import Combine

protocol GeneralSwapDutyInteractorProtocol {
    func fetchGroupOptions(bioId: String,campus:String) -> AnyPublisher<GroupResponseModel,Error>
}

class GeneralSwapDutyInteractor: GeneralSwapDutyInteractorProtocol {
    func fetchGroupOptions(bioId: String,campus:String) -> AnyPublisher<GroupResponseModel,Error> {
        guard let url = URL(string: "\(Constants.Base_URL)employee/groupOptions") else {
            return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
        }
        let param = ["bioId": bioId, "campus": campus]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: GroupResponseModel.self)
    }
}
