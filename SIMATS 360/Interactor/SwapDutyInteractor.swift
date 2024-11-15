//
//  SwapDutyInteractor.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 11/11/24.
//

import Foundation
import Combine

protocol SwapDutyInteractorProtocol {
    func requestSwapDuty(reqFromId: String,reqToId: String, dutyId: String) -> AnyPublisher<DutySwapModel,Error>
    func fetchSwapStatus(bioId: String) -> AnyPublisher<SwapDutyResponse,Error>
}

class SwapDutyInteractor: SwapDutyInteractorProtocol {
    func fetchSwapStatus(bioId: String) -> AnyPublisher<SwapDutyResponse, any Error> {
        guard let url = URL(string: "http://localhost:1312/employee/swapStatus") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
    
        let param = ["bioId": bioId]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: SwapDutyResponse.self)
    }
    
    func requestSwapDuty(reqFromId: String, reqToId: String, dutyId: String) -> AnyPublisher<DutySwapModel, any Error> {
        guard let url = URL(string: "http://localhost:1312/employee/swapDuty") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
    
        let param = ["requestFrom" : reqFromId, "requestTo": reqToId, "id": dutyId]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: DutySwapModel.self)
    }
    
    
}
