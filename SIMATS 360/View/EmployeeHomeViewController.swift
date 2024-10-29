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
    func showDutyCount(dutyData: DutyCountModel)
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
    var dutyCountResponse: DutyCountModel?
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var bioIdLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDefault()
        profileImgView.makeCircular()
        addTapActionForViews()
        initNavigationBar()
        loadProfileData()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.fetchHomeData()
    }
    
    private func loadDefault() {
        leaveBalance.text = "N/A"
        attendancePercentage.text = "N/A"
        bufferTime.text = "N/A"
    }
    
    @IBAction func applyLeaveTapped(_ sender: Any) {
        let leaveApplicationVC = ApplyLeaveRouter.createApplyLeaveRouter()
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
        self.view.stopLoader()
        self.showAlert(title: "", message: error)
    }
    
    func showDutyCount(dutyData: DutyCountModel) {
        dutyLabel.text = "\(dutyData.pendingCount) Duty"
//        if let status = dutyData.status, status {
//            
//        } else {
//            dutyLabel.text = "\(0) Duty"
//        }
    }
    
    func showAvailableLeave(leaveData: AvailableLeaveModel) {
        self.view.stopLoader()
        if let availableLeave = leaveData.data.first {
            self.availableLeaveData = leaveData
            let totalLeaveWithSick = Double(availableLeave.academicLeave) + Double(availableLeave.casualLeave) + availableLeave.sickLeave + Double(availableLeave.earnedLeave)
            leaveBalance.text = "\(totalLeaveWithSick) Days"
        }
        Constants.availableLeaveTypes = getLeaveTypes(leaveModel: leaveData)
    }
    
    func getLeaveTypes(leaveModel: AvailableLeaveModel) -> [String] {
        var leaveTypes: [String] = []
        
        for leaveData in leaveModel.data {
            if leaveData.casualLeave > 0 {
                leaveTypes.append("Casual Leave - \(leaveData.casualLeave)")
            }
            if leaveData.sickLeave > 0 {
                leaveTypes.append("Sick Leave - \(leaveData.sickLeave)")
            }
            if leaveData.earnedLeave > 0 {
                leaveTypes.append("Earned Leave - \(leaveData.earnedLeave)")
            }
            if leaveData.academicLeave > 0 {
                leaveTypes.append("Academic Leave - \(leaveData.academicLeave)")
            }
        }
        
        return leaveTypes
    }
    
    func showHomePageData(homeData: HomePageResponse) {
        self.view.stopLoader()
        if let userData = homeData.data.summary.first{
            self.homePageResponse = homeData
            attendancePercentage.text = "\(Int(userData.attendancePercentage))% for the current month"
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
            let bufferTimeVc = BufferTimeRouter.createBufferTime() as! BufferTimingViewController
            bufferTimeVc.attendanceData = self.homePageResponse?.data.attendance
            bufferTimeVc.attendanceSummary = self.homePageResponse?.data.summary
            self.navigationController?.pushViewController(bufferTimeVc, animated: true)
        }
        
        dutyView.addTap {
            let dutyVC = DutyRouter.navigateToDuty()
            self.navigationController?.pushViewController(dutyVC, animated: true)
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
    
    private func fetchHomeData() {
        if let userData = Constants.profileData.userData.first {
            self.view.startLoader()
            let date = Utils.getCurrentDateInYearMonthFormat()
            //let yearMonth = date.split(separator: ":")
           
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            homePresenter?.fetchHomeData(
                bioId: String(userData.bioID),
                campus: userData.campus,
                category: userData.category
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
            dispatchGroup.enter()
            homePresenter?.fetchDutyCounts(bioId: String(userData.bioID), completionHandler: {
                dispatchGroup.leave()
            })
            
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
