//
//  BufferTimePresenter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 21/10/24.
//

import Foundation
import Combine

protocol BufferTimePresenterProtocol: AnyObject {
    func fetchBufferTime(bioId: String, campus: String, category: String, year: String, month: String)
}


class BufferTimePresenter: BufferTimePresenterProtocol {
    
    weak var view: BufferTimeViewProtocol?
    var bufferInteractor: BufferTimeInteractorProtocol?
    private var cancelable = Set<AnyCancellable>()
    
    func fetchBufferTime(bioId: String, campus: String, category: String, year: String, month: String) {
        bufferInteractor?.fetchBufferTime(bioId: bioId, campus: campus, category: category, year: year, month: month).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case.failure(let err):
                self.view?.showError(error: err.localizedDescription)
            }
        }, receiveValue: { response in
            if response.status {
                self.view?.showBufferTime(bufferResponse: response)
            } else {
                self.view?.showError(error: response.message)
            }
        })
        .store(in: &cancelable)
    }
}

    
  
