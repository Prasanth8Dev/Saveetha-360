//
//  DutyRosterViewController.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 24/10/24.
//

import UIKit

class DutyRosterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    func initNavigationBar() {
        navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#F6F8F9"), titleColor: .black)
        navigationItem.title = "Duty Roster"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = false
        
        self.navigationController?.navigationBar.tintColor = .black
        let image = UIImage(named: "logo-tabbar")?.withRenderingMode(.alwaysOriginal) // Ensure the image is rendered
        let notificationButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(notificationTapped))
        
        notificationButton.tintColor = .clear
        
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        
        button.frame = CGRect(x: 0, y: 50, width: 50, height: 50)
        
        button.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItems = [notificationButton]
    }
    
     @objc func notificationTapped() {
         print("Right button tapped")
        
     }
}
