//
//  SalaryDetailsRouter.swift
//  Saveetha 360
//
//  Created by Prasanth S on 18/10/24.
//

import Foundation
import UIKit

protocol SalaryDetailsRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}
class SalaryDetailsRouter: SalaryDetailsRouterProtocol {
    
    static func createModule() -> UIViewController {
        let salaryDetailsVC: SalaryDetailsViewController = SalaryDetailsViewController.instantiate()
        
        let salaryPresenter = SalaryDetailsPresenter()
        let interactor: SalaryDetailsInteractor = SalaryDetailsInteractor()
//        let router: ReportsRouterProtocol = ReportsRouter()
        
        salaryDetailsVC.salaryDetailsPresenter = salaryPresenter
        salaryPresenter.salaryDetailsInteractor = interactor
        salaryPresenter.view = salaryDetailsVC
        
        return salaryDetailsVC
    }
    
    
}
