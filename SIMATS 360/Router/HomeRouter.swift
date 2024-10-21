//
//  HomeRouter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 21/10/24.
//

import Foundation
import UIKit

protocol HomeRouterProtocol: AnyObject {
    static func createHomeViewController() -> UIViewController
}

class HomeRouter: HomeRouterProtocol {
    static func createHomeViewController() -> UIViewController {
        let homeVC: EmployeeHomeViewController = EmployeeHomeViewController.instantiate()
        
        let homePresenter = HomePresenter()
        let homeInteractor = HomeInteractor()
        homeVC.homePresenter = homePresenter
        homePresenter.view = homeVC
        homePresenter.homeInteractor = homeInteractor
        
        return homeVC
    }
}
