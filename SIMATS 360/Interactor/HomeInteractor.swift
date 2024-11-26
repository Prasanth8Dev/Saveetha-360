//
//  HomeInteractor.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 21/10/24.
//

import Foundation
import Combine

protocol HomePageInteractorProtocol: AnyObject {
    func fetchHomePageData(bioId: String, campus: String, category: String) -> AnyPublisher<HomePageResponse, Error>
    func fetchAvailableLeave(bioId: String, campus: String, category: String) -> AnyPublisher<AvailableLeaveModel, Error>
    func fetchDutyCount(bioId: String) -> AnyPublisher<DutyCountModel, Error>
    func fetchGeneralDuties(bioId: String, campus: String) -> AnyPublisher<GeneralDutyModel, Error>
}

class HomeInteractor: HomePageInteractorProtocol {
    func fetchGeneralDuties(bioId: String, campus: String) -> AnyPublisher<GeneralDutyModel, any Error> {
        guard let url = URL(string: "http://localhost:1312/employee/generalDuty") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let param = ["bioId": bioId,
                     "campus": campus
                     ]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: GeneralDutyModel.self)
    }
    
    
    func fetchAvailableLeave(bioId: String, campus: String, category: String) -> AnyPublisher<AvailableLeaveModel, any Error> {
        guard let url = URL(string: "http://localhost:1312/employee/getAvailableLeave") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let param = ["bio_id": bioId,
                     "campus": campus,
                     "category": category
                     ]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: AvailableLeaveModel.self)
    }
    
    func fetchHomePageData(bioId: String, campus: String, category: String) -> AnyPublisher<HomePageResponse, Error> {
        guard let url = URL(string: "http://localhost:1312/employee/homeInfo") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let param = ["bioId": bioId,
                     "campus": campus,
                     "category": category]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: HomePageResponse.self)
    }
    
    func fetchDutyCount(bioId: String) -> AnyPublisher<DutyCountModel, any Error> {
        guard let url = URL(string: "http://localhost:1312/employee/pendingDutyCount") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let param = ["bioId": bioId]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: DutyCountModel.self)
    }
}
