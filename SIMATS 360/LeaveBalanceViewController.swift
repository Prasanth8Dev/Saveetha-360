//
//  LeaveBalanceViewController.swift
//  SIMATS 360
//
//  Created by Admin - iMAC on 04/10/24.
//

import UIKit

class LeaveBalanceViewController: UIViewController {

    @IBOutlet weak var earnedleave: UILabel!
    @IBOutlet weak var academicLeave: UILabel!
    @IBOutlet weak var sickLeave: UILabel!
    @IBOutlet weak var casualLeave: UILabel!
    var leaveData: AvailableLeaveModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadLeaveData()
    }
    
    private func loadLeaveData() {
        if let leaves = leaveData?.data.first {
            earnedleave.text = "Available Leaves: \(leaves.earnedLeave)"
            academicLeave.text = "Available Leaves: \(leaves.academicLeave)"
            sickLeave.text = "Available Leaves: \(leaves.sickLeave)"
            casualLeave.text = "Available Leaves: \(leaves.casualLeave)"
        }
    }
    
    func initNavigationBar() {
        navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#F6F8F9"), titleColor: .black)
        navigationItem.title = "Leave Balance"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = false
        
        self.navigationController?.navigationBar.tintColor = .black
        let image = UIImage(named: "logo 2")
        
        let notificationButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(notificationTapped))
        
        
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        
        button.frame = CGRect(x: 0, y: 50, width: 50, height: 50)
        
        button.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItems = [notificationButton]
        
    }
    
   
    @objc func notificationTapped() {
        print("Right button tapped")
       
    }
    @IBAction func applyLeaveTapped(_ sender: UIButton) {
        let leaveApplicationVC: LeaveApplicationViewController = LeaveApplicationViewController.instantiate()
        self.navigationController?.pushViewController(leaveApplicationVC, animated: true)
    }

}
