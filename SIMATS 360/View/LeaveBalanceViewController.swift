//
//  LeaveBalanceViewController.swift
//  SIMATS 360
//
//  Created by Admin - iMAC on 04/10/24.
//

import UIKit

protocol LeaveBalanceViewControllerProtocol: AnyObject {
    func showError(errorMessage: String)
    func loadLeaveData(response: LeaveDetailModel)
}

class LeaveBalanceViewController: UIViewController, LeaveBalanceViewControllerProtocol, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bioIdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var earnedleave: UILabel!
    @IBOutlet weak var academicLeave: UILabel!
    @IBOutlet weak var sickLeave: UILabel!
    @IBOutlet weak var casualLeave: UILabel!
    
    @IBOutlet weak var leaveDetailTableView: UITableView! {
        didSet {
            leaveDetailTableView.delegate = self
            leaveDetailTableView.dataSource = self
        }
    }
    
    var leaveData: AvailableLeaveModel?
    var leavePresenter: LeaveDetailPresenter?
    var leaveDetailResponse: LeaveDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadLeaveData()
        if let bioId = Constants.profileData.userData.first?.bioID, let campus = Constants.profileData.userData.first?.campus, let name = Constants.profileData.userData.first?.userName {
            leavePresenter?.fecthLeaveDetails(bioId: String(bioId), campus: campus)
            monthYearLabel.text = Utils.getCurrentYearWithMonth()
            userNameLabel.text = name
            bioIdLabel.text = "Bio Id: \(String(bioId))"
        }
       
    }
    
    private func loadLeaveData() {
        if let leaves = leaveData?.data.first {
            earnedleave.text = "Available Leaves: \(leaves.earnedLeave)"
            academicLeave.text = "Available Leaves: \(leaves.academicLeave)"
            sickLeave.text = "Available Leaves: \(leaves.sickLeave)"
            casualLeave.text = "Available Leaves: \(leaves.casualLeave)"
        }
    }
    
    func showError(errorMessage: String) {
        
    }
    
    func loadLeaveData(response: LeaveDetailModel) {
        self.leaveDetailResponse = response
        DispatchQueue.main.async {
            self.leaveDetailTableView.reloadData()
        }
    }
    
    func initNavigationBar() {
        navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#F6F8F9"), titleColor: .black)
        navigationItem.title = "Leave Balance"
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
    
    @IBAction func applyLeaveTapped(_ sender: UIButton) {
        let leaveApplicationVC = ApplyLeaveRouter.createApplyLeaveRouter() as! LeaveApplicationViewController
        self.navigationController?.pushViewController(leaveApplicationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.leaveDetailResponse?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveDatailTableViewCell", for: indexPath) as! LeaveDatailTableViewCell
        cell.selectionStyle = .none
        if let leaveData = self.leaveDetailResponse?.data[indexPath.row] {
            cell.leaveTypeLabel.attributedText =  Utils.attributedStringWithColorAndFont(text:  "Leave Type: \(leaveData.category)", colorHex: "#000000", font: UIFont.systemFont(ofSize: 8), length: 11)
            
            cell.fromDateLabel.attributedText =  Utils.attributedStringWithColorAndFont(text:  "Leave Date: \(leaveData.startDate)", colorHex: "#000000", font: UIFont.systemFont(ofSize: 16), length: 10)
            cell.toDateLabel.attributedText = Utils.attributedStringWithColorAndFont(text:  "To Date: \(leaveData.endDate)", colorHex: "#000000", font: UIFont.systemFont(ofSize: 16), length: 8)
            if leaveData.leaveType.lowercased().contains("full") {
                cell.leaveDurationLabel.attributedText =  Utils.attributedStringWithColorAndFont(text:  "Leave Duration: Full Day", colorHex: "#000000", font: UIFont.systemFont(ofSize: 16), length: 15)
            } else if leaveData.leaveType.lowercased().contains("half") {
                cell.leaveDurationLabel.attributedText = Utils.attributedStringWithColorAndFont(text:  "Leave Duration: Half Day", colorHex: "#000000", font: UIFont.systemFont(ofSize: 16), length: 15)
            }
            cell.toDateLabel.attributedText = Utils.attributedStringWithColorAndFont(text:  "Leave Status: \(leaveData.status)", colorHex: "#000000", font: UIFont.systemFont(ofSize: 16), length: 13)
           
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        leaveDetailTableView.deselectRow(at: indexPath, animated: true)
    }

}
