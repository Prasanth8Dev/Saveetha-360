//
//  SalaryDetailsInteractor.swift
//  Saveetha 360
//
//  Created by Prasanth S on 18/10/24.
//

import Foundation
import Combine

protocol SalaryDetailsInteractorProtocol {
    func fetchSalaryDetails(bioId: String) -> AnyPublisher<SalaryReportResponse,Error>
}

class SalaryDetailsInteractor: SalaryDetailsInteractorProtocol {
    
    
    
    func fetchSalaryDetails(bioId: String) -> AnyPublisher<SalaryReportResponse, any Error> {
        guard let url = URL(string: "\(Constants.Base_URL)employee/monthlySalaryReport") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let param = ["bioId" : bioId]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: SalaryReportResponse.self)
    }
    
    
}
