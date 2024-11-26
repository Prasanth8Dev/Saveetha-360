//
//  HolidayDutyClaimsViewController.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 25/11/24.
//

import UIKit
protocol HolidayDutyClaimsViewControllerProtocol {
    func showHomePageData(homeData: HomePageResponse)
    func showAlert(message: String)
}

class HolidayDutyClaimsViewController: UIViewController, HolidayDutyClaimsViewControllerProtocol, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var claimsView: UIView!
    @IBOutlet weak var requestClaims: UIView!
    @IBOutlet weak var claimsDateTF: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var holidayPresenter: HolidayDutyClaimsPresenterProtocol?
    var pickerView: UIPickerView!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    var homeData: HomePageResponse?
    var claimsDateWithCredits = [""]
    var requestCreditDates = [""]
    var isClaims = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
        self.title = "Holiday Claims"
        if let bioId = Constants.profileData.userData?.first?.bioID,
           let campus = Constants.profileData.userData?.first?.campus,
           let category = Constants.profileData.userData?.first?.category {
            holidayPresenter?.fetchHomePageData(bioId: String(bioId), campus: campus, category: category)
        }
        
        claimsView.addTap {
            self.resetImages()
            self.img1.image = UIImage(named: "Frame (2)")
            self.isClaims = true
        }
        requestClaims.addTap {
            self.isClaims = false
            self.resetImages()
            self.img2.image = UIImage(named: "Frame (2)")
        }
    }
    
    private func resetImages() {
        img1.image = UIImage(named: "Frame (3)")
        img2.image = UIImage(named: "Frame (3)")
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        guard let dateString = claimsDateTF.text, !dateString.isEmpty, let bioId = Constants.profileData.userData?.first?.bioID, let campus = Constants.profileData.userData?.first?.campus else { return }
        var credits = ""
        var date = ""
        var isRequest = false
        if dateString.contains("1") {
            credits = "1"
        } else if dateString.contains("0.5") {
            credits = "0.5"
        }
        if dateString.contains("Request") {
            isRequest = true
        }
        date = dateString.replacingOccurrences(of: "-", with: "")
        claimDuty(bioId: String(bioId), campus: campus, credits: credits, date: date, isRequest: isRequest)
    }
    
    private func claimDuty(bioId: String, campus: String, credits: String, date: String, isRequest: Bool) {
        if isRequest {
            holidayPresenter?.claimRequest(bioId: bioId, campus: campus, dutyDate: date, credits: credits)
        } else {
            holidayPresenter?.claimHoliday(bioId: bioId, campus: campus, dutyDate: date, credits: credits)
        }
    }
    
    private func setupPickerView() {
        // Initialize the picker view
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self

        claimsDateTF.inputView = pickerView

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true

        claimsDateTF.inputAccessoryView = toolbar
    }
    
    @objc private func dismissPicker() {
        // Dismiss the picker view
        view.endEditing(true)
    }
    
    func showHomePageData(homeData: HomePageResponse) {
        self.homeData = homeData
        
        claimsDateWithCredits = self.homeData?.data.attendance
            .filter { $0.holidayCredits == 2 || $0.holidayCredits == 4 }
            .map { attendance in
                let creditString: String
                if attendance.holidayCredits == 2 {
                    creditString = "1 Credit"
                } else if attendance.holidayCredits == 4 {
                    creditString = "0.5 Credit"
                } else {
                    creditString = ""
                }
                return "\(attendance.date) - \(creditString)"
            } ?? [""]
        
        requestCreditDates = self.homeData?.data.attendance
            .filter { $0.holidayCredits == 7 }
            .map { "\( $0.date) - 1 Request" } ?? [""]
        
        claimsDateWithCredits.append(contentsOf: requestCreditDates)
        pickerView.reloadAllComponents()
    }
    
    func showAlert(message: String) {
        self.showAlert(title: "", message: message)
    }
    
    // MARK: - UIPickerViewDelegate and UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return claimsDateWithCredits.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return claimsDateWithCredits[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Update the text field with the selected value
        claimsDateTF.text = claimsDateWithCredits[row]
    }
}
