//
//  NotificationViewController.swift
//  SIMATS 360
//
//  Created by Admin - iMAC on 01/10/24.
//

import UIKit

protocol NotificationViewControllerProtocol: AnyObject {
    func showGeneralNotification(data: NotificationModel)
    func showApprovalNotification(data: ApprovalNotificationModel)
    func showAlert(message: String)
}

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NotificationViewControllerProtocol {

    @IBOutlet weak var notificationTableView: UITableView! {
        didSet {
            notificationTableView.delegate = self
            notificationTableView.dataSource = self
            notificationTableView.separatorStyle = .none
        }
    }
    var notificationPresenter: NotificationPresenterProtocol?
    var genaralNotificationData: [NotificationData]?
    var approvalNotificationData: [RequestData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        initNavigationBar()
        fetchNotification()
    }
    
    func fetchNotification() {
        let dispatchgroup = DispatchGroup()

        dispatchgroup.enter()
        notificationPresenter?.fetchGeneralNotification(completionHandler: {
            dispatchgroup.leave()
        })
        if let bioId = Constants.profileData.userData.first?.bioID, let campus = Constants.profileData.userData.first?.campus {
            dispatchgroup.enter()
            notificationPresenter?.fetchApprovalNotification(bioId: String(bioId), campus: campus, completionHandler: {
                dispatchgroup.leave()
            })
        }
        
        dispatchgroup.notify(queue: DispatchQueue.main) {
            self.tableViewReload()
        }
    }
    
    func initNavigationBar() {
        navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#F6F8F9"), titleColor: .black)
        navigationItem.title = "Notifications"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.tintColor = .black
        let image = UIImage(named: "logo-tabbar")?.withRenderingMode(.alwaysOriginal) // Ensure the image is rendered
        let notificationButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(notificationTapped))
        
        notificationButton.tintColor = .clear
        
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        
        button.frame = CGRect(x: 0, y: 50, width: 30, height: 30)
        
        button.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItems = [notificationButton]
        
    }
   
    @objc func notificationTapped() {
        print("Right button tapped")
       
    }
    
    func showGeneralNotification(data: NotificationModel) {
        self.genaralNotificationData = data.notificationData
       
    }
    
    func showApprovalNotification(data: ApprovalNotificationModel) {
        self.approvalNotificationData = data.notificationData
        
    }
    
    private func tableViewReload() {
        if self.approvalNotificationData?.count ?? 0 > 0 || self.genaralNotificationData?.count ?? 0 > 0 {
            notificationTableView.reloadData()
        } else {
            // show the alert and hide the table view
        }
    }
    
    func showAlert(message: String) {
        self.showAlert(title: "", message: message)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.genaralNotificationData?.count ?? 0
        } else {
            return self.approvalNotificationData?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var DynamicCell = UITableViewCell()
        if indexPath.section == 0 {
           let cell = notificationTableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
            cell.imgView.image = UIImage(named: "Frame")
            cell.iconImg.image = UIImage(named: "Vector (14)")
            if let notificationdata = self.genaralNotificationData {
                cell.titleLabel.text = notificationdata[indexPath.row].notificationTitle
                cell.descriptionLabel.text = notificationdata[indexPath.row].notificationMessage
            }
            
            cell.imgView.makeCircular()
            DynamicCell = cell
        } else if indexPath.section == 1 {
            let cell = notificationTableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
            cell.imgView.image = UIImage(named: "approvalImg")
            cell.iconImg.image = UIImage(named: "approvalIcon")
            cell.iconImg.contentMode = .scaleAspectFill
            if let notificationdata = self.approvalNotificationData {
                cell.titleLabel.text = "Leave Request" /*notificationdata[indexPath.row].notificationTitle*/
                cell.descriptionLabel.text = notificationdata[indexPath.row].reason
            }
            cell.imgView.makeCircular()
            DynamicCell = cell
        }
        DynamicCell.selectionStyle = .none
        return DynamicCell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notificationTableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if let notification = self.genaralNotificationData {
                let detailNotificationVC: NotificationDetailViewController = NotificationDetailViewController.instantiate()
                detailNotificationVC.notificationData = notification[indexPath.row]
                detailNotificationVC.isGeneral = true
                self.present(detailNotificationVC, animated: true)
            }
        } else {
            if let approvalNotificationdata = self.approvalNotificationData {
                let detailNotificationVC: NotificationDetailViewController = NotificationDetailViewController.instantiate()
                detailNotificationVC.requestData = approvalNotificationdata[indexPath.row]
                detailNotificationVC.isApproval = true
                self.present(detailNotificationVC, animated: true)
               // self.navigationController?.pushViewController(detailNotificationVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(hex: "#F6F8F9")
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        
        if section == 0 {
            label.text = "Announcement"
        } else {
            label.text = "Approval"
        }
        
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
}
