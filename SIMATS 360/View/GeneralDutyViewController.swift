//
//  GeneralDutyViewController.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 23/11/24.
//

import UIKit
import FSCalendar

class GeneralDutyViewController: UIViewController,FSCalendarDelegate, FSCalendarDataSource {

    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var holidayClaimsView: UIView!
    @IBOutlet weak var generalDutyView: UIView!
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd"
        return formatter
    }()
    var generalDutyDates = [String]()
    
    @IBOutlet weak var claimsCountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let generalDuty = Constants.generalDutyModel {
            generalDutyDates = generalDuty.generalDuties.map({ $0.shiftDate})
        }
        setClaimsCounts()
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.reloadData()
        // Do any additional setup after loading the view.
    }
    private func setClaimsCounts() {
        var countStr = "\(0) Claims"
        if Constants.claimsCounts > 0 {
            countStr = "\(Constants.claimsCounts) \(Constants.claimsCounts <= 1 ? "Day" : "Days") Unclaimed"
        }
        if Constants.requestCounts > 0 {
            countStr += " \(Constants.requestCounts) Request available"
        }
        claimsCountLabel.text = countStr
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initNavigationBar()
        addTapAction()
    }
    
    private func addTapAction() {
        generalDutyView.addTap {
            guard self.generalDutyDates.count > 0 else {
                return self.showAlert(title: "", message: "There is no General Duties")
            }
            let vc = GeneralSwapDutyRouter.navigateToGeneralSwapDuty()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        holidayClaimsView.addTap {
            guard Constants.claimsCounts > 0.0 || Constants.requestCounts > 0.0 else {
                self.showAlert(title: "", message: "There is no Claims")
                return
            }
            let holidayClaimsVC = HolidayDutyClaimsRouter.createHolidayDutyClaimsViewController()
            self.navigationController?.pushViewController(holidayClaimsVC, animated: true)
        }
    }
    
    func initNavigationBar() {
        navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#F6F8F9"), titleColor: .black)
        navigationItem.title = "General Duty"
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
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let dateString = dateFormatter.string(from: date)
        
        if generalDutyDates.contains(dateString) {
            return UIColor.init(hex: "#FFFF00")
        }
        return nil
    }
}
