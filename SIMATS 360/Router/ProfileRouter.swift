//
//  ProfileRouter.swift
//  Saveetha 360
//
//  Created by Prasanth S on 17/10/24.
//

import Foundation
import UIKit

protocol ProfileRouterProtocol {
    static func createProfile() -> UIViewController
}

class ProfileRouter: ProfileRouterProtocol {
    static func createProfile() -> UIViewController {
        let profileVC: ProfileViewController = ProfileViewController.instantiate()
        let profilePresenter = ProfilePresenter()
        let interactor: ProfileInteractor = ProfileInteractor()
            
        profileVC.profilePresenter = profilePresenter
        
        
        profilePresenter.profileInteractor = interactor
        
        profilePresenter.view = profileVC
        return profileVC
    }
}
