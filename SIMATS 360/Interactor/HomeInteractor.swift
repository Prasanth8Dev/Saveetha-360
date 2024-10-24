//
//  HomeInteractor.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 21/10/24.
//

import Foundation
import Combine


//
//"bioId" : 3737,
//"campus" : "Saveetha Medical College",
//"category" : "teaching",
//"year" : 2024,
//"month" : 9

protocol HomePageInteractorProtocol: AnyObject {
    func fetchHomePageData(bioId: String, campus: String, category: String) -> AnyPublisher<HomePageResponse, Error>
    func fetchAvailableLeave(bioId: String, campus: String, category: String) -> AnyPublisher<AvailableLeaveModel, Error>
}

class HomeInteractor: HomePageInteractorProtocol {
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
}
