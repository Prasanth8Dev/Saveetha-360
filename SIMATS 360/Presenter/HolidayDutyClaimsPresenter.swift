//
//  HolidayDutyClaimsPresenter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 25/11/24.
//

import Foundation
import Combine

protocol HolidayDutyClaimsPresenterProtocol {
    func fetchHomePageData(bioId: String, campus: String, category: String)
    func claimHoliday(bioId: String, campus: String, dutyDate: String,credits: String)
    func claimRequest(bioId: String, campus: String, dutyDate: String,credits: String)
}

class HolidayDutyClaimsPresenter: HolidayDutyClaimsPresenterProtocol {
 
    var homeInteractor: HomePageInteractorProtocol?
    var view: HolidayDutyClaimsViewController?
    private var cancellables = Set<AnyCancellable>()
    var holidayClaimsInteractor: HolidayDutyClaimsInteractor?
    
    func fetchHomePageData(bioId: String, campus: String, category: String) {
        homeInteractor?.fetchHomePageData(bioId: bioId, campus: campus, category: category).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.view?.showAlert(message: error.localizedDescription)
            }
        }, receiveValue: { response in
            if response.status {
                self.view?.showHomePageData(homeData: response)
            } else  {
                self.view?.showAlert(title: "", message: response.message)
            }
            
        })
        .store(in: &cancellables)
    }
    
    func claimHoliday(bioId: String, campus: String, dutyDate: String, credits: String) {
        holidayClaimsInteractor?.claimHoliday(bioId: bioId, campus: campus, dutyDate: dutyDate, credits: credits).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let err):
                self.view?.showAlert(message: err.localizedDescription)
            case .finished:
                break
            }
        }, receiveValue: { response in
            if response.status {
                self.view?.showAlert(message: response.message)
            } else {
                self.view?.showAlert(message: response.message)
            }
        })
        .store(in: &cancellables)
    }
    
    func claimRequest(bioId: String, campus: String, dutyDate: String, credits: String) {
        holidayClaimsInteractor?.claimRequest(bioId: bioId, campus: campus, dutyDate: dutyDate, credits: credits).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let err):
                self.view?.showAlert(message: err.localizedDescription)
            case .finished:
                break
            }
        }, receiveValue: { response in
            if response.status {
                self.view?.showAlert(message: response.message)
            } else {
                self.view?.showAlert(message: response.message)
            }
        })
        .store(in: &cancellables)
    }
}
