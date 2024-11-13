//
//  NotificationDetailsRouter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 13/11/24.
//
import UIKit
import Foundation
protocol NotificationDetailsRouterProtocol {
    static func createRouter()-> UIViewController
}

class NotificationDetailsRouter: NotificationDetailsRouterProtocol {
    static func createRouter()-> UIViewController {
        let vc: NotificationDetailViewController = NotificationDetailViewController.instantiate()
        let notificationPresenter = NotificationDetailPresenter()
        let notificationInteractor = NotificationDetailsInteractor()
        
        vc.presenter = notificationPresenter
        notificationPresenter.view = vc
        notificationPresenter.interactor = notificationInteractor
        
        return vc
    }
}
