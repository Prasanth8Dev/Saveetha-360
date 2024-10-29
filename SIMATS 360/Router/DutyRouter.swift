//
//  DutyRouter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 28/10/24.
//

import Foundation
import UIKit

protocol DutyRouterProtocol {
    static func navigateToDuty() -> UIViewController
}

class DutyRouter: DutyRouterProtocol {
    
    static func navigateToDuty() -> UIViewController {
        let dutyVC: DutyViewController = DutyViewController.instantiate()
        let presenter = DutyPresenter()
        let dutyInteractor = DutyInteractor()
        dutyVC.dutyPrsentor = presenter
        presenter.dutyInteractor = dutyInteractor
        presenter.view = dutyVC
        return dutyVC
    }
}
