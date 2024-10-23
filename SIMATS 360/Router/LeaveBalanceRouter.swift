//
//  LeaveBalanceRouter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 22/10/24.
//

import Foundation
import UIKit

protocol LeaveBalanceRouterProtocol: AnyObject {
    static func createLeaveBalance() -> UIViewController
}

class LeaveBalanceRouter: LeaveBalanceRouterProtocol {
    static func createLeaveBalance() -> UIViewController {
        let leaveBalanceVC: LeaveBalanceViewController = LeaveBalanceViewController.instantiate()
        let presenter = LeaveDetailPresenter()
        let leaveInteractor = LeaveBalanceInteractor()
        
        leaveBalanceVC.leavePresenter = presenter
        presenter.view = leaveBalanceVC
        presenter.leaveBalanceInteractor = leaveInteractor
        
        return leaveBalanceVC
    }
}
