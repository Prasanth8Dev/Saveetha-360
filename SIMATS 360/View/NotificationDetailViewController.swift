//
//  NotificationDetailViewController.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 26/10/24.
//

import UIKit
protocol NotificationDetailViewControllerProtocol {
    func showMessage(message: String)
}

class NotificationDetailViewController: UIViewController, NotificationDetailViewControllerProtocol, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var notificationMessageLabel: UILabel!
    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bioIdLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var leaveDateLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var LeaveTypeLabel: UILabel!
    @IBOutlet weak var namelabel: UILabel!
    
    
    @IBOutlet weak var swapView: UIView!
    @IBOutlet weak var approveButton: UIButton!
    var presenter: NotificationDetailPresenter?
    var reload: (()-> Void)?
    
    @IBOutlet weak var rejectButton: UIButton!
    var notificationData: NotificationData?
    var requestData: RequestData?
    var swapNotificationData: SwapDutyNotification?
    var isGeneral: Bool = false
    var isApproval: Bool = false
    var isSwapDuty: Bool = false
    
    @IBOutlet weak var swapTimingTableView: UITableView!
    
    @IBOutlet weak var swapDutyTimeLabel: UILabel!
    @IBOutlet weak var swapNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swapView.isHidden = !isSwapDuty
        loadNotificationData()
        if let notificationData = self.notificationData {
            CoreDataManager.shared.updateGeneralNotifyInDB(notificationData)
//            CoreDataManager.shared.saveOrUpdateGeneralNotifyInDB(notificationData)
        }
        if let approvalNotificationData = self.requestData {
            CoreDataManager.shared.updateApproveNotifyInDB(approvalNotificationData)
        }
        dateLabel.isHidden = self.isApproval
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print(CoreDataManager.shared.fetchAllGeneralNotification())
        self.reload?()
        
    }
    
    func showMessage(message: String) {
        self.showAlertWithCompletion(title: "", message: message) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func approveTapped(_ sender: Any) {
        self.dismiss(animated: true)
        if let data = requestData {
            ConfirmLeaveRequest(leaveId: String(data.id), status: "Approved")
        }
    }
    
    
    @IBAction func rejectTapped(_ sender: Any) {
        self.dismiss(animated: true)
        if let data = requestData {
            ConfirmLeaveRequest(leaveId: String(data.id), status: "Rejected")
        }
    }
    
    @IBAction func swapRejectTapped(_ sender: Any) {
        if let swapId = self.swapNotificationData?.swapId {
            presenter?.updateSwapRequest(swapId: String(swapId), status: "Rejected")
        }
        
    }
    
    @IBAction func swapApproveTapped(_ sender: Any) {
        if let swapId = self.swapNotificationData?.swapId {
            presenter?.updateSwapRequest(swapId: String(swapId), status: "Approved")
        }
    }

    
    private func ConfirmLeaveRequest(leaveId: String, status: String) {
        presenter?.updateLeaveRequest(leaveId: leaveId, status: status)
    }
    
    func loadNotificationData() {
        if let userName = Constants.profileData.userData?.first?.userName, let bioId = Constants.profileData.userData?.first?.bioID {
            userNameLabel.text = userName
            bioIdLabel.text = "Bio Id: \(bioId)"
        }
        
        if isGeneral {
            if let data = notificationData {
                notificationTitleLabel.text = data.notificationTitle
                notificationMessageLabel.text = data.notificationMessage
                dateLabel.text = Utils.formatDateString(data.notificationCreatedAt)
                namelabel.isHidden = true
                LeaveTypeLabel.isHidden = true
                reasonLabel.isHidden = true
                leaveDateLabel.isHidden = true
                approveButton.isHidden = true
                rejectButton.isHidden = true
                
            }
        } else if isApproval {
            if let data = requestData {
                //let leaveDate = Utils.formatDateString(data.startDate)
                notificationTitleLabel.text = "Leave Request"
               // notificationMessageLabel.isHidden = true
                namelabel.attributedText = Utils.attributedStringWithColorAndFont(text:  "Name: \(data.employeeName)", colorHex:  "#000000", font: UIFont.systemFont(ofSize: 8), length: 5)
                LeaveTypeLabel.attributedText = Utils.attributedStringWithColorAndFont(text:  "Leave Type: \(data.leaveType)", colorHex:  "#000000", font: UIFont.systemFont(ofSize: 8), length: 11)
                reasonLabel.attributedText = Utils.attributedStringWithColorAndFont(text:  "Leave Reason: \(data.reason)", colorHex:  "#000000", font: UIFont.systemFont(ofSize: 8), length: 13)
                leaveDateLabel.attributedText = Utils.attributedStringWithColorAndFont(text:  "Leave Date: \(data.startDate)", colorHex:  "#000000", font: UIFont.systemFont(ofSize: 8), length: 11)
                notificationMessageLabel.attributedText = Utils.attributedStringWithColorAndFont(text:  "Leave Duration: \(data.leaveCategory)", colorHex:  "#000000", font: UIFont.systemFont(ofSize: 8), length: 15)
                
                approveButton.isHidden = false
                rejectButton.isHidden = false
            }
        } else if isSwapDuty {
            if let swapData = self.swapNotificationData {
               
                swapNameLabel.attributedText = Utils.attributedStringWithColorAndFont(text:  "Name: \(swapData.empName)", colorHex:  "#000000", font: UIFont.systemFont(ofSize: 8), length: 5)
                swapDutyTimeLabel.attributedText = Utils.attributedStringWithColorAndFont(text:  "Shift: \(swapData.shift)", colorHex:  "#000000", font: UIFont.systemFont(ofSize: 8), length: 6)
                swapTimingTableView.delegate = self
                swapTimingTableView.dataSource = self
                swapTimingTableView.rowHeight = UITableView.automaticDimension
                swapTimingTableView.estimatedRowHeight = 60
                swapTimingTableView.reloadData()
            }
        }
    }
    
  // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.swapNotificationData?.swipesData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = swapTimingTableView.dequeueReusableCell(withIdentifier: "SwapDutyTableViewCell", for: indexPath) as! SwapDutyTableViewCell
        if let data = self.swapNotificationData?.swipesData, let swipesData = data.first?.swipes {
            cell.dayLabel.text = data.first?.day
            if !swipesData[0].swipeTime.isEmpty {
                cell.day1Label.text = swipesData[0].swipeTime
            }
            if !swipesData[1].swipeTime.isEmpty {
                cell.day2Label.text = swipesData[1].swipeTime
            }
            if !swipesData[2].swipeTime.isEmpty {
                cell.day3Label.text = swipesData[2].swipeTime
            }
        }
        return cell
    }
}
