//
//  ReportsRouter.swift
//  Saveetha 360
//
//  Created by Prasanth S on 14/10/24.
//

import Foundation
import UIKit

protocol ReportsRouterProtocol {
    static func createReportsModule() -> UIViewController
}

class ReportsRouter: ReportsRouterProtocol {
    
    static func createReportsModule() -> UIViewController {
        let reportsVC: ReportsViewController = ReportsViewController.instantiate()
        let reportPresenter = ReportsPresenter()
        let interactor: SalaryReportInteractor = SalaryReportInteractor()
//        let router: ReportsRouterProtocol = ReportsRouter()
        
        reportsVC.reportsPresenter = reportPresenter
        reportPresenter.reportsInteractor = interactor
        reportPresenter.view = reportsVC
        
        return reportsVC
    }
    
   
    
    
}
