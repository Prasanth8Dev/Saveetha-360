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
    func showGeneralDutydata(dutyData: GeneralDutyModel)
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
    @IBOutlet weak var generalDutyView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bioIdLabel: UILabel!
    @IBOutlet weak var generalDutyCount: UILabel!
    
    var availableLeaveData: AvailableLeaveModel?
    var loginresponse: LoginResponse?
    var homePresenter: HomePresenterProtocol?
    var homePageResponse: HomePageResponse?
    var dutyCountResponse: DutyCountModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDefault()
        profileImgView.makeCircular()
        addTapActionForViews()
        initNavigationBar()
        loadProfileData()
        self.fetchHomeData()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
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
        guard let userData = loginresponse?.userData?.first else {
            print("No user data available")
            return
        }

        setBioIDLabel(from: userData)
        setUserNameLabel(from: userData)
        loadProfileImage(from: userData)
    }

    private func setBioIDLabel(from userData: UserData) {
        if let bioID = userData.bioID {
            bioIdLabel.text = "Bio Id: \(bioID)"
        } else {
            bioIdLabel.text = "Bio Id: Not available"
        }
    }

    private func setUserNameLabel(from userData: UserData) {
        userNameLabel.text = userData.userName ?? "No username available"
    }

    private func loadProfileImage(from userData: UserData) {
        if let profileImg = userData.profileImgURL {
            DispatchQueue.main.async {
                self.profileImgView.loadImage(from: profileImg)
            }
        } else {
            print("Profile image URL not available")
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
    
    func showGeneralDutydata(dutyData: GeneralDutyModel) {
        generalDutyCount.text = "\(dutyData.generalDuties.count) Duty"
        Constants.generalDutyModel = dutyData
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
            if leaveData.restrictedLeave > 0 {
                leaveTypes.append("Restricted Leave - \(leaveData.restrictedLeave)")
            }
            if leaveData.vacationLeave > 0 {
                leaveTypes.append("Vacation Leave - \(leaveData.vacationLeave)")
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
        homeData.data.attendance.forEach { attedanceData in
            if attedanceData.holidayCredits == 2 {
                Constants.claimsCounts += 1
                Constants.claimsDate.append(attedanceData.date)
            } else if attedanceData.holidayCredits == 4 {
                Constants.claimsCounts += 0.5
                Constants.claimsDate.append(attedanceData.date)
            } else if attedanceData.holidayCredits == 7 {
                Constants.requestCounts += 1
                Constants.requestDate.append(attedanceData.date)
            }
        }
    }
    
    private func addTapActionForViews() {
        generalDutyView.addTap {
            let generalDutyVC: GeneralDutyViewController = GeneralDutyViewController.instantiate()
            self.navigationController?.pushViewController(generalDutyVC, animated: true)
        }
        
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
        if let userData = Constants.profileData.userData?.first,  let bioID = userData.bioID , let campus = userData.campus, let category = userData.category {
            self.view.startLoader()
           
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            homePresenter?.fetchHomeData(
                bioId: String(bioID),
                campus: campus,
                category: category
               ) {
               
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            homePresenter?.fetchAvialableleave(
                bioId: String(bioID),
                campus: campus,
                category: category
            ) {
                dispatchGroup.leave()
            }
            dispatchGroup.enter()
            homePresenter?.fetchDutyCounts(bioId: String(bioID), completionHandler: {
                dispatchGroup.leave()
            })
            
            dispatchGroup.enter()
            homePresenter?.fetchGeneralDutyCounts(bioId: String(bioID), campus: campus, completionHandler: {
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
