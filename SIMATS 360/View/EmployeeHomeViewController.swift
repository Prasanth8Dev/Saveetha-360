//
//  EmployeeHomeViewController.swift
//  SIMATS 360
//
//  Created by Admin - iMAC on 01/10/24.
//

import UIKit

protocol EmployeeHomeViewProtocol: AnyObject {
    func showHomePageData(homeData: HomePageResponse)
    func showAvailableLeave(leaveData: AvailableLeaveModel)
    func showError(error: String)
}

class EmployeeHomeViewController: UIViewController, EmployeeHomeViewProtocol {
    
    @IBOutlet weak var dutyLabel: UILabel!
    @IBOutlet weak var leaveBalance: UILabel!
    @IBOutlet weak var bufferTime: UILabel!
    @IBOutlet weak var attendancePercentage: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var dutyView: UIView!
    @IBOutlet weak var leavebalanceView: UIView!
    @IBOutlet weak var bufferTimeView: UIView!
    @IBOutlet weak var attendanceView: UIView!
    
    var availableLeaveData: AvailableLeaveModel?
    var loginresponse: LoginResponse?
    var homePresenter: HomePresenterProtocol?
    var homePageResponse: HomePageResponse?
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var bioIdLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImgView.makeCircular()
        addTapActionForViews()
        initNavigationBar()
        loadProfileData()
      
    }
    
    @IBAction func applyLeaveTapped(_ sender: Any) {
        let leaveApplicationVC: LeaveApplicationViewController = LeaveApplicationViewController.instantiate()
        self.navigationController?.pushViewController(leaveApplicationVC, animated: true)
    }
    
    private func loadProfileData() {
        if let userData = loginresponse?.userData.first {
            bioIdLabel.text = "Bio Id:\(String(userData.bioID))"
            userNameLabel.text = userData.userName
            DispatchQueue.main.async {
                //guard let `self` = self else {return}
                self.profileImgView.loadImage(from: userData.profileImgURL)
            }
        }
    }
    
    func showError(error: String) {
        self.showAlert(title: "", message: error)
    }
  
    func showAvailableLeave(leaveData: AvailableLeaveModel) {
        if let availableLeave = leaveData.data.first {
            self.availableLeaveData = leaveData
            let totalLeaveWithSick = Double(availableLeave.academicLeave) + Double(availableLeave.casualLeave) + availableLeave.sickLeave + Double(availableLeave.earnedLeave)
            leaveBalance.text = "\(totalLeaveWithSick) Days"
        }
    }
    
    func showHomePageData(homeData: HomePageResponse) {
        if let userData = homeData.data.first{
            self.homePageResponse = homeData
            attendancePercentage.text = "\(userData.attendancePercentage)% for the current month"
            bufferTime.text = "\(Int(userData.adjustedBuffTime)) Minutes"
        }
    }
    
    private func addTapActionForViews() {
        leavebalanceView.addTap {
            let leaveBalanceVC = LeaveBalanceRouter.createLeaveBalance() as! LeaveBalanceViewController
            leaveBalanceVC.leaveData = self.availableLeaveData
            self.navigationController?.pushViewController(leaveBalanceVC, animated: true)
        }
        
        attendanceView.addTap {
            let attendanceVC: AttendanceViewController = AttendanceViewController.instantiate()
            attendanceVC.attendanceResponse = self.homePageResponse
            self.navigationController?.pushViewController(attendanceVC, animated: true)
        }
        
        bufferTimeView.addTap {
            let bufferTimeVc = BufferTimeRouter.createBufferTime()
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
     
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if let userData = Constants.profileData.userData.first {
            let date = Utils.getCurrentDateInYearMonthFormat()
            let yearMonth = date.split(separator: ":")
           
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            homePresenter?.fetchHomeData(
                bioId: String(userData.bioID),
                campus: userData.campus,
                category: userData.category,
                year: String(yearMonth[0]),
                month: String(yearMonth[1])
            ) {
               
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            homePresenter?.fetchAvialableleave(
                bioId: String(userData.bioID),
                campus: userData.campus,
                category: userData.category
            ) {
                dispatchGroup.leave()
            }

     
            dispatchGroup.notify(queue: .main) {
      
                print("Both API calls are completed.")
            }
        }
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar when this view disappears
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }



}
