//
//  UIViewControllerExtension.swift
//  Simats HRMS
//
//  Created by Admin - iMAC on 17/09/24.
//

import Foundation
import UIKit

extension UIViewController {
    class func instantiate<T: UIViewController>() -> T {
        let storyBoardId = String(describing: T.self)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: storyBoardId) as! T
    }
    
    class func instantiateTabbar<T: UITabBarController>() -> T {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "EmployeeTabBarViewController") as! T
    }
    
    
    func customizeNavigationBar(title: String?, titleColor: UIColor = .black, titleFont: UIFont = UIFont.boldSystemFont(ofSize: 18), backButtonOffset: UIOffset = UIOffset(horizontal: -1000, vertical: 0), tintColor: UIColor = .white) {
        // Customize navigation bar title appearance
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: titleColor,
            .font: titleFont
        ]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        
        // Customize back button title position adjustment
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(backButtonOffset, for: .default)
        
        // Customize navigation bar tint color
        navigationController?.navigationBar.tintColor = tintColor
        
        // Set the navigation bar title
        title.map { self.title = $0 }
    }
}
