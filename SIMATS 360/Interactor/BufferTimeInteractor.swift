//
//  BufferTimeInteractor.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 21/10/24.
//

import Foundation
import Combine

protocol BufferTimeInteractorProtocol: AnyObject {
    func fetchBufferTime(bioId: String, campus: String, category: String, year: String, month: String) -> AnyPublisher<BufferTimeModel, Error>
}

class BufferTimeInteractor: BufferTimeInteractorProtocol {
    func fetchBufferTime(bioId: String, campus: String, category: String, year: String, month: String) -> AnyPublisher<BufferTimeModel, Error> {
        guard let url = URL(string: "http://localhost:1312/employee/monthlyBufferDetails") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let param = ["bioId": bioId,
                     "campus": campus,
                     "category": category,
                     "year": year,
                     "month": month
                     ]
        return APIWrapper.shared.postRequestMethod(url: url, body: param, responseType: BufferTimeModel.self)
    }
}
