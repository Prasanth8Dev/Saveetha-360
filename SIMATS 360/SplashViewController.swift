//
//  SplashViewController.swift
//  SIMATS 360
//
//  Created by Admin - iMAC on 03/10/24.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigateToTabbar()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
    }
    
    func navigateToTabbar() {
        let tabbar: EmployeeTabBarViewController = EmployeeTabBarViewController.instantiateTabbar()
        self.navigationController?.pushViewController(tabbar, animated: true)
    }


}
