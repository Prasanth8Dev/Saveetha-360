//
//  GeneralSwapDutyRouter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 23/11/24.
//

import Foundation

protocol GeneralSwapDutyRouterProtocol {
    static func navigateToGeneralSwapDuty() -> GeneralSwapDutyViewController
}

class GeneralSwapDutyRouter: GeneralSwapDutyRouterProtocol {
    
    static func navigateToGeneralSwapDuty() -> GeneralSwapDutyViewController {
        let vc: GeneralSwapDutyViewController = GeneralSwapDutyViewController.instantiate()
        let generalDutyPresenter = GeneralSwapDutyPresenter()
        let generalDutyInteractor = GeneralSwapDutyInteractor()
        
        generalDutyPresenter.interactor = generalDutyInteractor
        generalDutyPresenter.view = vc
        vc.presenter = generalDutyPresenter
        return vc
        
    }
}
