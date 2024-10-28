//
//  AttendanceViewController.swift
//  SIMATS 360
//
//  Created by Admin - iMAC on 04/10/24.
//

import UIKit
import FSCalendar

class AttendanceViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet weak var imgFour: UIImageView!
    @IBOutlet weak var imgThree: UIImageView!
    @IBOutlet weak var imgTwo: UIImageView!
    @IBOutlet weak var imgOne: UIImageView!
    
    @IBOutlet weak var attendanceCalendar: FSCalendar!
    @IBOutlet weak var attendancePercentage: UILabel!
    @IBOutlet weak var totalWorkingDays: UILabel!
    @IBOutlet weak var daysAbsent: UILabel!
    @IBOutlet weak var daysPresent: UILabel!
    var attendanceResponse: HomePageResponse?
    var presentDates: [String] = []
    var absentDates: [String] = []
    let dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "dd-MM-yyyy"
           return formatter
       }()
    
    @IBOutlet weak var bioIdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var monthTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgFour.makeCircular()
        imgThree.makeCircular()
        imgTwo.makeCircular()
        imgOne.makeCircular()
        initNavigationBar()
        loadAttendanceData()
        filterPresentDates()
        attendanceCalendar.delegate = self
        attendanceCalendar.dataSource = self
       
        // Do any additional setup after loading the view.
    }
    
    private func filterPresentDates() {
        if let attedanceResponse = self.attendanceResponse?.data.attendance {
            presentDates = attedanceResponse.filter {$0.presence.lowercased() == "present"}.map({ $0.date })
            absentDates = attedanceResponse.filter {$0.presence.lowercased() == "absent"}.map({ $0.date })
            attendanceCalendar.reloadData()
        }
    }
    
    private func loadAttendanceData() {
        if let data = attendanceResponse?.data.summary.first {
            attendancePercentage.text = "Attendance percentage: \(Int(data.attendancePercentage))"
            totalWorkingDays.text = "Total Working days: \(data.totalWorkingDays)"
            daysAbsent.text = "Days Absent: \(data.absentDays)"
            daysPresent.text = "Days Present: \(data.presentDays)"
            monthTF.text = Utils.getCurrentMonth()
            monthTF.isUserInteractionEnabled = false
            DispatchQueue.main.async {
                if let userImage = Constants.profileData.userData.first?.profileImgURL, let userName = Constants.profileData.userData.first?.userName, let bioId = Constants.profileData.userData.first?.bioID {
                    self.userNameLabel.text = userName
                    self.bioIdLabel.text = "Bio Id: \(String(bioId))"
                    self.imgFour.loadImage(from: userImage)
                    self.imgThree.loadImage(from: userImage)
                    self.imgTwo.loadImage(from: userImage)
                    self.imgOne.loadImage(from: userImage)
                }
            }
        }
    }
    
    func initNavigationBar() {
        navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#F6F8F9"), titleColor: .black)
        navigationItem.title = "Attendance"
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
    
    // MARK: - FSCalendarDelegateAppearance Methods
       
       func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
           let dateString = dateFormatter.string(from: date)
          
           if presentDates.contains(dateString) {
               return UIColor.init(hex: "#008000") // Mark present dates in green
           }
           
           if absentDates.contains(dateString) {
               return UIColor.init(hex: "#EE4B2B") // Mark absent dates in red
           }
           
           if Calendar.current.isDateInToday(date) {
               return UIColor.init(hex: "#17C6ED")
           }
           return nil
       }
       
       
       func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
           let dateString = dateFormatter.string(from: date)
           
           // Optional: Change text color for specific dates if needed
           if presentDates.contains(dateString) || absentDates.contains(dateString) {
               return UIColor.white // Make the text white for better contrast on colored backgrounds
           }
           
           return nil // Default color
       }
    
}
