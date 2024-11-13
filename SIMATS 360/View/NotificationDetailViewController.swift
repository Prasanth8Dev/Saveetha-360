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

class NotificationDetailViewController: UIViewController, NotificationDetailViewControllerProtocol {

    @IBOutlet weak var notificationMessageLabel: UILabel!
    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bioIdLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var leaveDateLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var LeaveTypeLabel: UILabel!
    @IBOutlet weak var namelabel: UILabel!
    
    
    @IBOutlet weak var approveButton: UIButton!
    var presenter: NotificationDetailPresenter?
    var reload: (()-> Void)?
    
    @IBOutlet weak var rejectButton: UIButton!
    var notificationData: NotificationData?
    var requestData: RequestData?
    var isGeneral: Bool = false
    var isApproval: Bool = false
    var isSwapDuty: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotificationData()
        if let notificationData = self.notificationData {
            CoreDataManager.shared.updateGeneralNotifyInDB(notificationData)
//            CoreDataManager.shared.saveOrUpdateGeneralNotifyInDB(notificationData)
        }
       
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
    
    private func ConfirmLeaveRequest(leaveId: String, status: String) {
    
        presenter?.updateLeaveRequest(leaveId: leaveId, status: status)
        
    }
    
    func loadNotificationData() {
        if let userName = Constants.profileData.userData.first?.userName, let bioId = Constants.profileData.userData.first?.bioID {
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
            
        }
    }
}
