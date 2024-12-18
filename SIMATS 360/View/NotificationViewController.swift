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
    func showSwapNotification(data: SwapDutyDataResponse)
    func showAlert(message: String)
}

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NotificationViewControllerProtocol {
   
    @IBOutlet weak var notificationSegment: UISegmentedControl!
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
    var swapNotifications: SwapDutyDataResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func fetchGeneralNotificationFromDB() {
        self.genaralNotificationData = CoreDataManager.shared.fetchAllGeneralNotification()
        if self.genaralNotificationData?.count ?? 0 > 0 {
            tableViewReload()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        initNavigationBar()
        fetchNotification()
        fetchGeneralNotificationFromDB()
        fetchApproveNotificationsFromDB()
    }
    
    func fetchNotification() {
        if let campus = Constants.profileData.userData?.first?.campus {
            let dispatchgroup = DispatchGroup()
            
            dispatchgroup.enter()
            notificationPresenter?.fetchGeneralNotification(campus: campus, completionHandler: {
                dispatchgroup.leave()
            })
            if let bioId = Constants.profileData.userData?.first?.bioID, let campus = Constants.profileData.userData?.first?.campus {
                dispatchgroup.enter()
                notificationPresenter?.fetchApprovalNotification(bioId: String(bioId), campus: campus, completionHandler: {
                    dispatchgroup.leave()
                })
                
                dispatchgroup.enter()
                notificationPresenter?.fetchSwapNotifications(bioId: String(bioId), campus: campus, completionHandler: {
                    dispatchgroup.leave()
                })
            }
            
            dispatchgroup.notify(queue: DispatchQueue.main) {
                let unopenedCounts = self.genaralNotificationData?.filter({$0.isOpened == false})
                let unReadApprovalCounts = self.approvalNotificationData?.filter({$0.isOpened == false})
                self.notificationSegment.setTitle("Announcement (\(unopenedCounts?.count ?? 0))", forSegmentAt: 0)
                self.notificationSegment.setTitle("Approval (\(unReadApprovalCounts?.count ?? 0))", forSegmentAt: 1)
                self.notificationSegment.setTitle("Swap", forSegmentAt: 2)
                self.tableViewReload()
            }
        }
    }
    
    @IBAction func segmentTapped(_ sender: Any) {
        notificationTableView.reloadData()
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
       // self.genaralNotificationData = data.notificationData
        if data.notificationData.count > 0 {
            CoreDataManager.shared.saveGeneralNotifyInDB(data.notificationData)
//            data.notificationData.forEach({ data in
//                CoreDataManager.shared.saveGeneralNotifyInDB(data)
//            })
            fetchGeneralNotificationFromDB()
        } else {
            CoreDataManager.shared.deleteAllGeneralNotifications()
        }
        
    }
    
    
    func showSwapNotification(data: SwapDutyDataResponse) {
        self.swapNotifications = data
    }
    
    func showApprovalNotification(data: ApprovalNotificationModel) {
        if data.notificationData.count > 0 {
            CoreDataManager.shared.saveApproveNotifyInDB(data.notificationData)
//            data.notificationData.forEach({ data in
//                CoreDataManager.shared.saveApproveNotifyInDB(data)
//            })
            fetchApproveNotificationsFromDB()
        } else {
            CoreDataManager.shared.deleteAllApproveNotifications()
        }
        
    }
    
    private func fetchApproveNotificationsFromDB() {
        self.approvalNotificationData = CoreDataManager.shared.fetchAllApproveNotification()
        tableViewReload()
    }
    
    private func tableViewReload() {
        if self.approvalNotificationData?.count ?? 0 > 0 || self.genaralNotificationData?.count ?? 0 > 0 || self.swapNotifications?.swapDutyNotificationData?.count ?? 0 > 0 {
            notificationTableView.reloadData()
        } else {
            // show the alert and hide the table view
        }
    }
    
    func showAlert(message: String) {
        self.showAlert(title: "", message: message)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notificationSegment.selectedSegmentIndex == 0 {
            return self.genaralNotificationData?.count ?? 0
        } else if notificationSegment.selectedSegmentIndex == 1 {
            return self.approvalNotificationData?.count ?? 0
        } else if notificationSegment.selectedSegmentIndex == 2 {
            return self.swapNotifications?.swapDutyNotificationData? .count ?? 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dynamicCell = UITableViewCell()
        if notificationSegment.selectedSegmentIndex == 0 {
           let cell = notificationTableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
            cell.imgView.image = UIImage(named: "Frame")
            
            
            if let notificationdata = self.genaralNotificationData {
                cell.iconImg.image = UIImage(named:  notificationdata[indexPath.row].isOpened ? "read" : "unread")
                cell.titleLabel.text = notificationdata[indexPath.row].notificationTitle
                cell.descriptionLabel.text = notificationdata[indexPath.row].notificationMessage
            }
            
            cell.imgView.makeCircular()
            dynamicCell = cell
        } else if notificationSegment.selectedSegmentIndex == 1 {
            let cell = notificationTableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
            cell.imgView.image = UIImage(named: "approvalImg")
            cell.iconImg.image = UIImage(named: "approvalIcon")
            cell.iconImg.contentMode = .scaleAspectFill
            if let notificationdata = self.approvalNotificationData {
                cell.titleLabel.text = "Leave Request" /*notificationdata[indexPath.row].notificationTitle*/
                cell.descriptionLabel.text = notificationdata[indexPath.row].reason
                cell.iconImg.image = UIImage(named:  notificationdata[indexPath.row].isOpened ? "read" : "unread")
            }
            cell.imgView.makeCircular()
            dynamicCell = cell
        } else if notificationSegment.selectedSegmentIndex == 2 {
            let cell = notificationTableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
            if let swapNotification = self.swapNotifications?.swapDutyNotificationData, swapNotification.count > 0 {
                cell.titleLabel.text = "Swap Request \n \(swapNotification[indexPath.row].empName)"
                cell.descriptionLabel.text = "\(swapNotification[indexPath.row].shift)"
            }
            dynamicCell = cell
        }
        
        dynamicCell.selectionStyle = .none
        return dynamicCell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notificationTableView.deselectRow(at: indexPath, animated: true)
        if notificationSegment.selectedSegmentIndex == 0 {
            if let notification = self.genaralNotificationData {
                let detailNotificationVC: NotificationDetailViewController = NotificationDetailViewController.instantiate()
                detailNotificationVC.notificationData = notification[indexPath.row]
                detailNotificationVC.isGeneral = true
                detailNotificationVC.reload = { [weak self] in
                    self?.fetchGeneralNotificationFromDB()
                }
                self.present(detailNotificationVC, animated: true)
            }
        } else if notificationSegment.selectedSegmentIndex == 1 {
            if let approvalNotificationdata = self.approvalNotificationData {
                let detailNotificationVC = NotificationDetailsRouter.createRouter() as! NotificationDetailViewController
                detailNotificationVC.requestData = approvalNotificationdata[indexPath.row]
                detailNotificationVC.isApproval = true
                
                detailNotificationVC.reload = { [weak self] in
                    self?.fetchApproveNotificationsFromDB()
                }
              //  self.present(detailNotificationVC, animated: true)
               self.navigationController?.pushViewController(detailNotificationVC, animated: true)
            }
        } else if notificationSegment.selectedSegmentIndex == 2 {
            if let swapNotificationData = self.swapNotifications?.swapDutyNotificationData?[indexPath.row] {
                let detailNotificationVC = NotificationDetailsRouter.createRouter() as! NotificationDetailViewController
                detailNotificationVC.swapNotificationData = swapNotificationData
                detailNotificationVC.isSwapDuty = true
                self.navigationController?.pushViewController(detailNotificationVC, animated: true)
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor(hex: "#F6F8F9")
//        
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        label.textColor = .black
//        
//        if section == 0 {
//            label.text = "Announcement"
//        } else {
//            label.text = "Approval"
//        }
//        
//        headerView.addSubview(label)
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
//            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
//        ])
//        
//        return headerView
//    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
}
