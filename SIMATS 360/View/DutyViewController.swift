//
//  DutyViewController.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 09/10/24.
//

import UIKit
import FSCalendar

protocol DutyViewControllerProtocol: AnyObject {
    func showMessage(Str: String)
    func showPendingDutyData(_ data: DutyDataModel)
}

class DutyViewController: UIViewController, DutyViewControllerProtocol, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance  {

    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var claimsView: UIView!
    @IBOutlet weak var swapDutyView: UIView!
    @IBOutlet weak var dutyRosterView: UIView!
    
    @IBOutlet weak var unclaimedLabel: UILabel!
    var dutyPrsentor: DutyPresenterProtocol?
    var dutyPendingDates:[String] = []
    let dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyy-MM-dd"
           return formatter
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapAction()
        fetchDutyData()
        calendarView.delegate = self
        calendarView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    private func fetchDutyData() {
        if let bioId = Constants.profileData.userData.first?.bioID {
            dutyPrsentor?.fetchPendingDuty(bioId: String(bioId))
        }
    }
    
    private func setupTapAction() {
        initNavigationBar()
        claimsView.addTap {
            let claimsVC: ClaimsViewController = ClaimsViewController.instantiate()
            self.navigationController?.pushViewController(claimsVC, animated: true)
        }
        
        swapDutyView.addTap {
            let swapDutyVC: SwapDutyViewController = SwapDutyViewController.instantiate()
            self.navigationController?.pushViewController(swapDutyVC, animated: true)
        }
        
        dutyRosterView.addTap {
            let dutyDetailVC: DutyRosterViewController = DutyRosterViewController.instantiate()
            self.navigationController?.pushViewController(dutyDetailVC, animated: true)
        }
    }
    
    func showMessage(Str: String) {
        self.showAlert(title: "", message: Str)
    }
    
    func showPendingDutyData(_ data: DutyDataModel) {
        dutyPendingDates = data.result.map { $0.startdate}
        print(dutyPendingDates)
        if !dutyPendingDates.isEmpty {
            calendarView.reloadData()
        }
    }
    
    func initNavigationBar() {
        navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#F6F8F9"), titleColor: .black)
        navigationItem.title = "Duty"
        self.navigationController?.navigationBar.isHidden = false
        
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium // Change as needed
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDateString = dateFormatter.string(from: date)
        print("Selected date: \(selectedDateString)")
        if dutyPendingDates.contains(selectedDateString) {
            self.showAlert(title: "", message: "fhjbfjfjfbfewfy")
        }
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("Deselected date: \(date)")
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let dateString = dateFormatter.string(from: date)
       
        if dutyPendingDates.contains(dateString) {
            return UIColor.init(hex: "#FF5F15") // Mark present dates in green
        }
      
        if Calendar.current.isDateInToday(date) {
            return UIColor.init(hex: "#17C6ED")
        }
        return nil
    }
}
