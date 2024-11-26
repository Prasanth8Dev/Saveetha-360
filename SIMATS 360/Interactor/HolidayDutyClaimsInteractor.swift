//
//  HolidayDutyClaimsInteractor.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 25/11/24.
//

import Foundation
import Combine

protocol HolidayDutyClaimsInteractorProtocol {
    func fetchHomePageData(bioId: String, campus: String, category: String) -> AnyPublisher<HomePageResponse, Error>
    func claimHoliday(bioId: String, campus: String, dutyDate: String,credits: String) -> AnyPublisher<ClaimsResponseModel, Error>
    func claimRequest(bioId: String, campus: String, dutyDate: String,credits: String) -> AnyPublisher<ClaimsResponseModel, Error>
}

class HolidayDutyClaimsInteractor: HolidayDutyClaimsInteractorProtocol {
    func claimHoliday(bioId: String, campus: String, dutyDate: String,credits: String) -> AnyPublisher<ClaimsResponseModel, any Error> {
        guard let url = URL(string: "http://localhost:1312/employee/claimHolidayCredits") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let param = ["bioId": bioId,
                     "campus": campus,
                     "dutyDate": dutyDate,
                     "credits":credits]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: ClaimsResponseModel.self)
    }
    
    func claimRequest(bioId: String, campus: String, dutyDate: String,credits: String) -> AnyPublisher<ClaimsResponseModel, any Error> {
        guard let url = URL(string: "http://localhost:1312/employee/requestClaimHoliday") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let param = ["bioId": bioId,
                     "campus": campus,
                     "dutyDate": dutyDate,
                     "credits":credits]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: ClaimsResponseModel.self)
    }
    
    func fetchHomePageData(bioId: String, campus: String, category: String) -> AnyPublisher<HomePageResponse, any Error> {
        guard let url = URL(string: "http://localhost:1312/employee/homeInfo") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let param = ["bioId": bioId,
                     "campus": campus,
                     "category": category]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: HomePageResponse.self)
    }
    
    
}
