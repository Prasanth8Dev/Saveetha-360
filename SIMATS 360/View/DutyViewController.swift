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
    func showClaimsData(_ data: ClaimsDataModel)
    func getGropuData(_ data: GroupResponseModel)
}

class DutyViewController: UIViewController, DutyViewControllerProtocol, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance  {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var claimsView: UIView!
    @IBOutlet weak var swapDutyView: UIView!
    @IBOutlet weak var dutyRosterView: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var unclaimedLabel: UILabel!
    var dutyPrsentor: DutyPresenterProtocol?
    var dutyPendingDates:[String] = []
    var dutyCompletedDates:[String] = []
    var pendingDutyData: [Result]?
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd"
        return formatter
    }()
    
    @IBOutlet weak var dutyDetailsView: UIStackView!
    @IBOutlet weak var detailDutySwipe: UILabel!
    @IBOutlet weak var detailDutyShift: UILabel!
    @IBOutlet weak var detailDutyDate: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    private var blurEffectView: UIVisualEffectView?
    var pendingDuty: DutyDataModel?
    var dutyClaim: ClaimsDataModel?
    var groupData: GroupResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapAction()
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.appearance.todayColor = .lightGray // Set the color for today to clear
        calendarView.appearance.todaySelectionColor = .lightGray
        calendarView.appearance.headerDateFormat = "MMMM yyyy"
        setupYearNavigationButtons()
        setupBlurView()
        dutyDetailsView.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }
    
    func setupYearNavigationButtons() {
        // Create Previous Year Button
        let previousYearButton = UIButton(type: .system)
        previousYearButton.setTitle("<<", for: .normal)
        previousYearButton.addTarget(self, action: #selector(goToPreviousYear), for: .touchUpInside)
        previousYearButton.translatesAutoresizingMaskIntoConstraints = false // Use Auto Layout
        previousYearButton.backgroundColor = .clear // Temporary color to debug
        frontView.addSubview(previousYearButton)
        
        // Create Next Year Button
        let nextYearButton = UIButton(type: .system)
        nextYearButton.setTitle("  >>", for: .normal)
        nextYearButton.addTarget(self, action: #selector(goToNextYear), for: .touchUpInside)
        nextYearButton.translatesAutoresizingMaskIntoConstraints = false // Use Auto Layout
        nextYearButton.backgroundColor = .clear // Temporary color to debug
        backView.addSubview(nextYearButton)
    }
    
    
    @objc func goToPreviousYear() {
        changeCalendarYear(by: -1)
    }
    
    @objc func goToNextYear() {
        changeCalendarYear(by: 1)
    }
    
    func changeCalendarYear(by yearOffset: Int) {
        let currentPage = calendarView.currentPage
        var dateComponents = DateComponents()
        dateComponents.year = yearOffset
        
        if let newDate = Calendar.current.date(byAdding: dateComponents, to: currentPage) {
            calendarView.setCurrentPage(newDate, animated: true)
        }
    }
    
    private func setupBlurView() {
        let blurEffect = UIBlurEffect(style: .light) // Choose your desired style
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView?.isHidden = true // Start hidden
        blurEffectView?.alpha = 0.1
        if let blurEffectView = blurEffectView {
            scrollView.addSubview(blurEffectView)
        }
    }
    
    private func fetchDutyData() {
        if let bioId = Constants.profileData.userData?.first?.bioID, let campus = Constants.profileData.userData?.first?.campus {
            dutyPrsentor?.fetchPendingDuty(bioId: String(bioId))
            dutyPrsentor?.fetchClaims(bioId: String(bioId))
            dutyPrsentor?.fetchGroupOptions(bioId: String(bioId), campus: campus)
        }
    }
    
    func showClaimsData(_ data: ClaimsDataModel) {
        self.dutyClaim = data
        unclaimedLabel.text = "\(data.claimsData.count) Days Unclaimed"
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dutyDetailsView.isHidden = true
        closeButton.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.blurEffectView?.alpha = 0
        }) { _ in
            self.blurEffectView?.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDutyData()
    }
    
    private func setupTapAction() {
        initNavigationBar()
        claimsView.addTap {
            let claimsVC = ClaimsRouter.createClaimsRouter() as! ClaimsViewController
            claimsVC.claimsData =  self.dutyClaim
            self.navigationController?.pushViewController(claimsVC, animated: true)
        }
        
        swapDutyView.addTap {
            let swapDutyVC = SwapDutyRouter.createRouter() as! SwapDutyViewController
            swapDutyVC.groupResponse = self.groupData
            swapDutyVC.pendingDuty = self.pendingDutyData
            self.navigationController?.pushViewController(swapDutyVC, animated: true)
        }
        
        dutyRosterView.addTap {
            let dutyDetailVC = DutyRosterRouter.navigateToDutyRoster() as! DutyRosterViewController
            self.navigationController?.pushViewController(dutyDetailVC, animated: true)
        }
    }
    
    func showMessage(Str: String) {
        self.showAlert(title: "", message: Str)
    }
    
    func getGropuData(_ data: GroupResponseModel) {
        self.groupData = data
    }
    
    func showPendingDutyData(_ data: DutyDataModel) {
        pendingDuty = data
        dutyPendingDates = data.result.filter({$0.dutyStatus.lowercased() == "pending"}).map({$0.startdate})
        dutyCompletedDates = data.result.filter({$0.dutyStatus.lowercased() == "completed"}).map({$0.startdate})
        pendingDutyData = data.result.filter({$0.dutyStatus.lowercased() == "pending"})
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
        if let duty = pendingDuty?.result.first(where: { $0.startdate == selectedDateString }) {
            let startDate = duty.startdate
            let shift = duty.shift
            let swipeDetails = duty.swipeDetails
            showDutyDetails(date: startDate, shift: shift, swipe: swipeDetails)
            
        }
    }
    
    private func showDutyDetails(date: String, shift: String, swipe: String) {
        DispatchQueue.main.async {
            let swipeData = swipe.split(separator: ";")
            self.dutyDetailsView.isHidden = false
            self.closeButton.isHidden = false
            self.blurEffectView?.alpha = 0.1
            self.blurEffectView?.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.blurEffectView?.alpha = 1
            }
            
            self.detailDutySwipe.attributedText = Utils.attributedStringWithColorAndFont(text:  "Swipe Deatils: \n ✦  \(swipeData[0]) \n ✦ \(swipeData[1]) \n ✦ \(swipeData[2])", colorHex: "#000000", font: UIFont.systemFont(ofSize: 24), length: 14)
            self.detailDutyShift.attributedText = Utils.attributedStringWithColorAndFont(text:  "Duty Shift: \n ✦ \(shift)", colorHex: "#000000", font: UIFont.systemFont(ofSize: 8), length: 11)
            self.detailDutyDate.attributedText = Utils.attributedStringWithColorAndFont(text:  "Duty Date: \n ✦ \(date)", colorHex: "#000000", font: UIFont.systemFont(ofSize: 8), length: 10)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("Deselected date: \(date)")
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let dateString = dateFormatter.string(from: date)
        
        if dutyPendingDates.contains(dateString) {
            return UIColor.init(hex: "#FF5F15")
        }
        
        if dutyCompletedDates.contains(dateString) {
            return UIColor.init(hex: "#008000")
        }
        //        if Calendar.current.isDateInToday(date) {
        //            return UIColor.white
        //        }
        return nil
    }
}
