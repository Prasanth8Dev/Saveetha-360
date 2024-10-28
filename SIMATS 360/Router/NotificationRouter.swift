//
//  NotificationRouter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 25/10/24.
//

import Foundation
import UIKit

protocol NotificationRouterProtocol {
    static func navigateToNotification() -> UIViewController
}

class NotificationRouter: NotificationRouterProtocol {
    static func navigateToNotification() -> UIViewController {
        let notificationVC: NotificationViewController = NotificationViewController.instantiate()
        let presenter = NotificationPresenter()
        let interactor = NotificationInteractor()
        
        notificationVC.notificationPresenter = presenter
        
        presenter.notificationView = notificationVC
        presenter.notificationInteractor = interactor
        
        return notificationVC
        
    }
    
    
}
