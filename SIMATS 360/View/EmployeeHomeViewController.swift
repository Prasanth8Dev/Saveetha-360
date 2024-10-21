//
//  EmployeeHomeViewController.swift
//  SIMATS 360
//
//  Created by Admin - iMAC on 01/10/24.
//

import UIKit

class EmployeeHomeViewController: UIViewController {

    @IBOutlet weak var profileImgView: UIImageView!
    
    @IBOutlet weak var dutyView: UIView!
    @IBOutlet weak var leavebalanceView: UIView!
    @IBOutlet weak var bufferTimeView: UIView!
    @IBOutlet weak var attendanceView: UIView!
    
    var loginresponse: LoginResponse?
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var bioIdLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImgView.makeCircular()
        addTapActionForViews()
        initNavigationBar()
        loadProfileData()
      
    }
    
    private func loadProfileData() {
        if let userData = loginresponse?.userData.first {
            bioIdLabel.text = "Bio Id:\(String(userData.bioID))"
            userNameLabel.text = userData.userName
            DispatchQueue.main.async {
                //guard let `self` = self else {return}
                self.profileImgView.loadImage(from: userData.profileImageUrl)
            }
        }
    }
    
    private func addTapActionForViews() {
        leavebalanceView.addTap {
            let leaveBalanceVC: LeaveBalanceViewController = LeaveBalanceViewController.instantiate()
            self.navigationController?.pushViewController(leaveBalanceVC, animated: true)
        }
        attendanceView.addTap {
            let attendanceVC: AttendanceViewController = AttendanceViewController.instantiate()
            self.navigationController?.pushViewController(attendanceVC, animated: true)
        }
        
        bufferTimeView.addTap {
            let bufferTimeVc: BufferTimeViewController = BufferTimeViewController.instantiate()
            self.navigationController?.pushViewController(bufferTimeVc, animated: true)
        }
        
        dutyView.addTap {
            let dutyVc: DutyViewController = DutyViewController.instantiate()
            self.navigationController?.pushViewController(dutyVc, animated: true)
        }
    }
    func initNavigationBar() {
        // Hide the navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Optionally update the appearance for when it's shown again
        self.navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#F6F8F9"), titleColor: .white)
        
        // Set the title and hide the back button if navigation bar becomes visible again
        self.navigationItem.title = "Notifications"
        self.navigationItem.hidesBackButton = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar when this view appears
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar when this view disappears
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }



}
