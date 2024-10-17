//
//  EmployeeTabBarViewController.swift
//  Simats HRMS
//
//  Created by Admin - iMAC on 17/09/24.
//

import UIKit
import SwiftUI

class EmployeeTabBarViewController: UITabBarController {

    //var menu: SideMenuNavigationController?
    var loginData: LoginResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewControllers()
      //  initNavigationBar()
       // initSideMenuBar()
        initTabbarApperance()
       //setupTabBar()
       initNavigationBar()
    }
    
    func initNavigationBar() {
        //navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#F6F8F9"), titleColor: .white)
        //navigationItem.title = "Notifications"
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func initViewControllers() {
        let empVC: EmployeeHomeViewController = EmployeeHomeViewController.instantiate()
        empVC.tabBarItem.image = UIImage(named: "homeIcon")
        empVC.tabBarItem.title = "Home"
        empVC.loginresponse = self.loginData
        let empNavVC = UINavigationController(rootViewController: empVC)

        let notificationVC: NotificationViewController = NotificationViewController.instantiate()
        notificationVC.tabBarItem.image = UIImage(named: "Notifications")
        notificationVC.tabBarItem.title = "Notifications"
        let notificationNavVC = UINavigationController(rootViewController: notificationVC)

        let salaryVC = ReportsRouter.createReportsModule()
        salaryVC.tabBarItem.image = UIImage(named: "Reports")
        salaryVC.tabBarItem.title = "Reports"
        salaryVC.navigationItem.title = "Reports"
        salaryVC.title = "Salary Reports"
        let salaryNavVC = UINavigationController(rootViewController: salaryVC)

        let profileVC: ProfileViewController = ProfileViewController.instantiate()
        profileVC.tabBarItem.image = UIImage(named: "ProfileTabbar")
        profileVC.tabBarItem.title = "Profile"
        let profileNavVC = UINavigationController(rootViewController: profileVC)

        // Assign the navigation controllers to the tab bar's viewControllers
        viewControllers = [empNavVC, notificationNavVC, salaryNavVC, profileNavVC]
    }

    
    func initTabbarApperance() {
        let customColor = UIColor(hex: "#ffffff")
        
        // Customize tab bar appearance
        let appearance = UITabBarAppearance()
        
        // Set the background color
        appearance.backgroundColor = customColor
        
        // Increase text size
        let largerFont = UIFont.boldSystemFont(ofSize: 12) // Text size for selected items
        let normalFont = UIFont.systemFont(ofSize: 10)     // Text size for unselected items
        
        // Set the color and font for selected items
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(hex: "#17c6ed"),
            .font: largerFont
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(hex: "#17c6ed")
        
        // Set the color and font for unselected items
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(hex: "#7e8a8c"),
            .font: normalFont
        ]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(hex: "#7e8a8c")
        
        // Apply the appearance to the tab bar
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
//        tabBar.layer.cornerRadius = 20
//        tabBar.layer.masksToBounds = true
        
        // Resize the icons manually
        resizeTabBarIcons()
    }

    func resizeTabBarIcons() {
        if let tabItems = tabBar.items {
            for tabItem in tabItems {
                // Resize the selected icon
                if let image = tabItem.selectedImage?.withRenderingMode(.alwaysOriginal) {
                    tabItem.selectedImage = resizeImage(image: image, targetSize: CGSize(width: 20, height: 20))
                }
                // Resize the unselected icon
                if let image = tabItem.image?.withRenderingMode(.alwaysOriginal) {
                    tabItem.image = resizeImage(image: image, targetSize: CGSize(width: 18, height: 18))
                }
            }
        }
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = CGSize(width: size.width * widthRatio, height: size.height * heightRatio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? image
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // Iterate through each tab item to find the selected one
        for tabBarItem in tabBar.items ?? [] {
            let isSelected = (tabBarItem == item)
            
            // Update the text size and color when the tab is selected
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: isSelected ? UIColor(hex: "#17c6ed") : UIColor(hex: "#7E8A8C"),
                .font: isSelected ? UIFont.boldSystemFont(ofSize: 12) : UIFont.systemFont(ofSize: 10)
            ]
            
            // Apply attributes to the tab item
            tabBarItem.setTitleTextAttributes(attributes, for: .normal)
            tabBarItem.setTitleTextAttributes(attributes, for: .selected)
        }
    }
}
//    func initNavigationBar() {
//        self.navigationController?.isNavigationBarHidden = false
//        navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#3C3D37"), titleColor: .white)
//        navigationItem.title = "SIMATS-360"
//        self.navigationController?.navigationBar.isHidden = false
//        self.navigationItem.hidesBackButton = true
//
//        self.navigationController?.navigationBar.tintColor = .white
//        let image = UIImage(named: "bell")
//        let image2 = UIImage(named: "profile")?.resizeImage(to: CGSize(width: 30, height: 30))
//
//        // Create a circular UIImageView for the logout image
//        let logoutImageView = UIImageView(image: image2)
//        logoutImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        logoutImageView.layer.cornerRadius = logoutImageView.frame.size.width / 2
//        logoutImageView.contentMode = .scaleAspectFill
//        logoutImageView.clipsToBounds = true
//
//        // Use the UIImageView inside a UIButton
//        let logoutButton = UIBarButtonItem(customView: logoutImageView)
//
//        logoutButton.customView?.addAction(for: .tap, Action: {
//            let profileView = EmployeeProfileView()
//            let hostingVC = UIHostingController(rootView: profileView)
//            self.navigationController?.pushViewController(hostingVC, animated: true)
//        })
//        let notificationButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(notificationTapped))
//        let profileButton = UIBarButtonItem(image: image2, style: .plain, target: self, action: #selector(logoutTapped))
//
//        self.navigationItem.rightBarButtonItems = [logoutButton ,notificationButton]
//    }

//
//    @objc func logoutTapped() {
//        print("Right button tapped")
//
//    }
//    private func navigateToProfileView() {
//
//    }
//
//    @objc func notificationTapped() {
//        print("Right button tapped")
//
//    }
//    func initSideMenuBar(){
//        let sideMenu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SuperAdminSideViewController") as! SuperAdminSideViewController
//        menu = SideMenuNavigationController(rootViewController: sideMenu)
//        menu?.leftSide = true
//        SideMenuManager.default.leftMenuNavigationController = menu
//        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "updatedSideMenu"), style: .plain, target: self, action: #selector(presentSideMenu))
//    }
//
//    @objc func presentSideMenu() {
//        self.present(menu!, animated: true)
//    }
