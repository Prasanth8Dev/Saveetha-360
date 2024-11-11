//
//  SwapDutyRouter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 11/11/24.
//

import Foundation
import UIKit

protocol SwapDutyRouterProtocol {
    static func createRouter() -> UIViewController
}

class SwapDutyRouter: SwapDutyRouterProtocol {
    static func createRouter() -> UIViewController {
        let swapDutyVC: SwapDutyViewController = SwapDutyViewController.instantiate()
        let presenter = SwapDutyPresenter()
        let interactor = SwapDutyInteractor()
        
        swapDutyVC.swapPresenter = presenter
        presenter.view = swapDutyVC
        presenter.swapInteractor = interactor
        return swapDutyVC
        
    }
    
    
}
