//
//  ReportsInteractor.swift
//  Saveetha 360
//
//  Created by Prasanth S on 14/10/24.
//

import Foundation
import Combine

protocol SalaryReportInteractorProtocol {
    func fetchSalaryReports(bioId: String) -> AnyPublisher<SalaryReportModel,Error>
}

class SalaryReportInteractor: SalaryReportInteractorProtocol {
    
    func fetchSalaryReports(bioId: String) -> AnyPublisher<SalaryReportModel, any Error> {
        guard let url = URL(string: "\(Constants.Base_URL)employee/salaryReports") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let param = ["bioId" : bioId]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: SalaryReportModel.self)
    }
}
