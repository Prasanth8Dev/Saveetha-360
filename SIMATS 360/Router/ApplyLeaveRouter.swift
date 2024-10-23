//
//  ApplyLeaveRouter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 23/10/24.
//

import Foundation
import UIKit

protocol LeaveApplyRouterProtocol: AnyObject {
    static func createApplyLeaveRouter() -> UIViewController
}

class ApplyLeaveRouter: LeaveApplyRouterProtocol {
    static func createApplyLeaveRouter() -> UIViewController {
        let leaveApplyVC: LeaveApplicationViewController = LeaveApplicationViewController.instantiate()
        var applyLeavePresenter = LeaveApplyPresenter()
        var applyLeaveInteractor = LeaveApplyInteractor()
        
        leaveApplyVC.leaveApplyPresenter = applyLeavePresenter
        applyLeavePresenter.view = leaveApplyVC
        applyLeavePresenter.applyLeaveInteractor = applyLeaveInteractor
        
        return leaveApplyVC
    }
}
