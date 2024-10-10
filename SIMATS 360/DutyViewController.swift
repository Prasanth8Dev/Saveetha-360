//
//  DutyViewController.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 09/10/24.
//

import UIKit

class DutyViewController: UIViewController {

    @IBOutlet weak var claimsView: UIView!
    @IBOutlet weak var swapDutyView: UIView!
    @IBOutlet weak var dutyRosterView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapAction()
        // Do any additional setup after loading the view.
    }
    
    private func setupTapAction() {
        initNavigationBar()
        claimsView.addTap {
            let claimsVC: ClaimsViewController = ClaimsViewController.instantiate()
            self.navigationController?.pushViewController(claimsVC, animated: true)
        }
        
        swapDutyView.addTap {
            let swapDutyVC: SwapDutyViewController = SwapDutyViewController.instantiate()
            self.navigationController?.pushViewController(swapDutyVC, animated: true)
        }
        
        dutyRosterView.addTap {
//            let duty
        }
    }
    
    func initNavigationBar() {
        navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#F6F8F9"), titleColor: .black)
        navigationItem.title = "Duty"
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.navigationBar.tintColor = .black
        let image = UIImage(named: "logo 2")
        
        let notificationButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(notificationTapped))
        
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        
        button.frame = CGRect(x: 0, y: 50, width: 30, height: 30)
        
        button.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItems = [notificationButton]
        
    }
    
   
    @objc func notificationTapped() {
        print("Right button tapped")
       
    }
}
