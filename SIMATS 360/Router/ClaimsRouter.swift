//
//  ClaimsRouter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 29/10/24.
//

import Foundation
import UIKit

protocol ClaimsRouterProtocol {
    static func createClaimsRouter() -> UIViewController
}

class ClaimsRouter: ClaimsRouterProtocol {
    static func createClaimsRouter() -> UIViewController {
        let claimsVC: ClaimsViewController = ClaimsViewController.instantiate()
        let presenter = ClaimsPresenter()
        let interactor = ClaimsInteractor()
        
        claimsVC.claimsPresenter = presenter
        presenter.claimsInteractor = interactor
        presenter.view = claimsVC
        return claimsVC
    }
}
