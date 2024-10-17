//
//  LoginRouter.swift
//  Saveetha 360
//
//  Created by Prasanth S on 14/10/24.
//

import Foundation
import UIKit

protocol LoginRouterProtocol {
    static func createLoginModule() -> UIViewController
    func navigateToHome(from view: LoginViewProtocol,successResponse: LoginResponse)
}

class LoginRouter: LoginRouterProtocol {
    static func createLoginModule() -> UIViewController {
        let view:LoginViewController = LoginViewController.instantiate()
        let presenter = LoginPresenter()
        let interactor: LoginInteractorProtocol = LoginInteractor()
        let router: LoginRouterProtocol = LoginRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        return view
    }

    func navigateToHome(from view: LoginViewProtocol, successResponse: LoginResponse) {
        print("-----------")
        let tabbar: EmployeeTabBarViewController = EmployeeTabBarViewController.instantiateTabbar()
        if let sourceView = view as? UIViewController {
            tabbar.loginData = successResponse
            sourceView.navigationController?.pushViewController(tabbar, animated: true)
        }
    }
}
