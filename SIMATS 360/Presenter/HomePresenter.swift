//
//  HomePresenter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 21/10/24.
//

import Foundation
import Combine

protocol HomePresenterProtocol: AnyObject {
    func fetchHomeData(bioId: String, campus: String, category: String, completionHandler: @escaping () -> Void)
    func fetchAvialableleave(bioId: String, campus: String, category: String,completionHandler: @escaping () -> Void)
    func fetchDutyCounts(bioId: String, completionHandler: @escaping () -> Void)
    func fetchGeneralDutyCounts(bioId: String,campus: String, completionHandler: @escaping () -> Void)
}

class HomePresenter: HomePresenterProtocol {
    var view: EmployeeHomeViewProtocol?
    var homeInteractor: HomePageInteractorProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    func fetchHomeData(bioId: String, campus: String, category: String, completionHandler: @escaping () -> Void) {
        homeInteractor?.fetchHomePageData(bioId: bioId, campus: campus, category: category)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    completionHandler()
                    self?.view?.showError(error: error.localizedDescription)
                }
                 // Ensure `completionHandler` is always called
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                if response.status {
                    self.view?.showHomePageData(homeData: response)
                } else {
                    self.view?.showError(error: response.message)
                }
                completionHandler() // Ensure `completionHandler` is called once
            })
            .store(in: &cancellables)
    }
    
    func fetchAvialableleave(bioId: String, campus: String, category: String, completionHandler: @escaping () -> Void) {
        homeInteractor?.fetchAvailableLeave(bioId: bioId, campus: campus, category: category)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    completionHandler()
                    self?.view?.showError(error: err.localizedDescription)
                }
                 // Ensure `completionHandler` is always called
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                if response.status {
                    self.view?.showAvailableLeave(leaveData: response)
                } else {
                    self.view?.showError(error: response.message)
                }
                completionHandler() // Ensure `completionHandler` is called once
            })
            .store(in: &cancellables)
    }
    
    func fetchDutyCounts(bioId: String, completionHandler: @escaping () -> Void) {
        homeInteractor?.fetchDutyCount(bioId: bioId)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    completionHandler()
                    self?.view?.showError(error: err.localizedDescription)
                }
                 // Ensure `completionHandler` is always called
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                if response.status {
                    self.view?.showDutyCount(dutyData: response)
                } else {
                    self.view?.showError(error: response.message) // Add error handling
                }
                completionHandler() // Ensure `completionHandler` is called once
            })
            .store(in: &cancellables)
    }
    
    func fetchGeneralDutyCounts(bioId: String, campus: String, completionHandler: @escaping () -> Void) {
        homeInteractor?.fetchGeneralDuties(bioId: bioId, campus: campus)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    completionHandler() 
                    self?.view?.showError(error: err.localizedDescription)
                }
                // Ensure `completionHandler` is always called
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                if response.status {
                    self.view?.showGeneralDutydata(dutyData: response)
                } else {
                   // self.view?.showError(error: response.message) // Add error handling
                }
                completionHandler() // Ensure `completionHandler` is called once
            })
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}
