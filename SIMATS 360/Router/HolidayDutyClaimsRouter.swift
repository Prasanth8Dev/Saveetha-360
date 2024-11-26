//
//  HolidayDutyClaimsRouter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 25/11/24.
//

import Foundation
protocol HolidayDutyClaimsRouterProtocol {
    static func createHolidayDutyClaimsViewController() -> HolidayDutyClaimsViewController
}

class HolidayDutyClaimsRouter: HolidayDutyClaimsRouterProtocol {
    
    static func createHolidayDutyClaimsViewController() -> HolidayDutyClaimsViewController {
        let holidayDutyClaimsVC: HolidayDutyClaimsViewController = HolidayDutyClaimsViewController.instantiate()
        let presenter = HolidayDutyClaimsPresenter()
        let interactor = HolidayDutyClaimsInteractor()
        let homeInteractor = HomeInteractor()
        presenter.holidayClaimsInteractor = interactor
        presenter.homeInteractor = homeInteractor
        holidayDutyClaimsVC.holidayPresenter = presenter
        presenter.view = holidayDutyClaimsVC
        
        return holidayDutyClaimsVC
    }
}
