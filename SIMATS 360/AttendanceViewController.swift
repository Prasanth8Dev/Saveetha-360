//
//  AttendanceViewController.swift
//  SIMATS 360
//
//  Created by Admin - iMAC on 04/10/24.
//

import UIKit

class AttendanceViewController: UIViewController {

    @IBOutlet weak var imgFour: UIImageView!
    @IBOutlet weak var imgThree: UIImageView!
    @IBOutlet weak var imgTwo: UIImageView!
    @IBOutlet weak var imgOne: UIImageView!
    
    @IBOutlet weak var attendancePercentage: UILabel!
    @IBOutlet weak var totalWorkingDays: UILabel!
    @IBOutlet weak var daysAbsent: UILabel!
    @IBOutlet weak var daysPresent: UILabel!
    var attendanceResponse: HomePageResponse?
    
    @IBOutlet weak var monthTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgFour.makeCircular()
        imgThree.makeCircular()
        imgTwo.makeCircular()
        imgOne.makeCircular()
        initNavigationBar()
        loadAttendanceData()
        // Do any additional setup after loading the view.
    }
    
    private func loadAttendanceData() {
        if let data = attendanceResponse?.data.first {
            attendancePercentage.text = "Attendance percentage: \(data.attendancePercentage)"
            totalWorkingDays.text = "Total Working days: \(data.totalWorkingDays)"
            daysAbsent.text = "Days Absent: \(data.absentDays)"
            daysPresent.text = "Days Present: \(data.presentDays)"
            monthTF.text = Utils.getCurrentMonth()
            monthTF.isUserInteractionEnabled = false
            DispatchQueue.main.async {
                if let userImage = Constants.profileData.userData.first?.profileImgURL {
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
        let image = UIImage(named: "logo 2")
        
        let notificationButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(notificationTapped))
        
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        
        button.frame = CGRect(x: 0, y: 50, width: 30, height: 30)
        
        button.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItems = [notificationButton]
        
    }
    
   
    @objc func notificationTapped() {
        print("Right button tapped")
       
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
