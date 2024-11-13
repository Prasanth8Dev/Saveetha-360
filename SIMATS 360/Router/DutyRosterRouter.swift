//
//  DutyRosterRouter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 13/11/24.
//

import Foundation
import UIKit

protocol DutyRosterRouterProtocol {
    static func navigateToDutyRoster() -> UIViewController
}

class DutyRosterRouter: DutyRosterRouterProtocol {
    
    static func navigateToDutyRoster() -> UIViewController {
        let vc: DutyRosterViewController = DutyRosterViewController.instantiate()
        let dutyRosterPresenter = DutyRosterPresenter()
        let dutRosterInteractor = DutyRosterInteractor()
        vc.presenter = dutyRosterPresenter
        dutyRosterPresenter.dutyRosterView = vc
        dutyRosterPresenter.interactor = dutRosterInteractor
        return vc
    }
}
