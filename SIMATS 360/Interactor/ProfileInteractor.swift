//
//  ProfileInteractor.swift
//  Saveetha 360
//
//  Created by Prasanth S on 17/10/24.
//

import Foundation
import Combine

protocol ProfileInteractorProtocol {
    func fetchProfile(bioId: String, campus: String) -> AnyPublisher<ProfileDataModel,Error>
}
class ProfileInteractor: ProfileInteractorProtocol {
    func fetchProfile(bioId: String, campus: String) -> AnyPublisher<ProfileDataModel, any Error> {
        guard let url = URL(string: "http://localhost:1312/employee/userInfo") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let param = ["bio_id" : bioId,
                     "campus": campus]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: ProfileDataModel.self)
    }
    
    
}
