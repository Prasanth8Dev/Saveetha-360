//
//  DutyRosterViewController.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 24/10/24.
//

import UIKit
protocol DutyRosterViewControllerProtocol{
    func showDutyData(_ data: DutyRosterModel)
    func showMessage(message: String)
}

class DutyRosterViewController: UIViewController, DutyRosterViewControllerProtocol, UITableViewDelegate, UITableViewDataSource {

    var presenter: DutyRosterPresenter?
    
    @IBOutlet weak var fromDateTF: UITextField!
    @IBOutlet weak var toDateTF: UITextField!
    
    private var fromDatePicker: UIDatePicker!
    private var toDatePicker: UIDatePicker!
    var rosterData: DutyRosterModel?
    
    @IBOutlet weak var dutyRosterTableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        setupDatePickers()
        dutyRosterTableview.delegate = self
        dutyRosterTableview.dataSource = self
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        guard let fromDateText = fromDateTF.text, !fromDateText.isEmpty,
              let toDateText = toDateTF.text, !toDateText.isEmpty else {
            showMessage(message: "Please select both dates.")
            return
        }
        if let bioID = Constants.profileData.userData.first?.bioID, let campus = Constants.profileData.userData.first?.campus {
            presenter?.dutyRosterData(fromDate: fromDateText, toDate: toDateText, campus: campus, bioId: String(bioID))
        }
        print("From Date: \(fromDateText), To Date: \(toDateText)")
    }
    
    func initNavigationBar() {
        navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#F6F8F9"), titleColor: .black)
        navigationItem.title = "Duty Roster"
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = false
        navigationController?.navigationBar.tintColor = .black
        
        let image = UIImage(named: "logo-tabbar")?.withRenderingMode(.alwaysOriginal)
        let notificationButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(notificationTapped))
        notificationButton.tintColor = .clear
        navigationItem.rightBarButtonItems = [notificationButton]
    }
    
    @objc func notificationTapped() {
        print("Right button tapped")
    }
    
    func showDutyData(_ data: DutyRosterModel) {
        print(data)
        self.rosterData = data
        dutyRosterTableview.reloadData()
    }
    
    func showMessage(message: String) {
        self.showAlert(title: "", message: message)
    }
    
    private func setupDatePickers() {
        fromDatePicker = UIDatePicker()
        fromDatePicker.datePickerMode = .date
        fromDatePicker.preferredDatePickerStyle = .wheels
        fromDatePicker.addTarget(self, action: #selector(fromDateChanged), for: .valueChanged)
        fromDateTF.inputView = fromDatePicker
        fromDateTF.inputAccessoryView = createToolbar(for: #selector(doneFromDate))
        
        toDatePicker = UIDatePicker()
        toDatePicker.datePickerMode = .date
        toDatePicker.preferredDatePickerStyle = .wheels
        toDatePicker.addTarget(self, action: #selector(toDateChanged), for: .valueChanged)
        toDateTF.inputView = toDatePicker
        toDateTF.inputAccessoryView = createToolbar(for: #selector(doneToDate))
    }
    
    @objc private func fromDateChanged() {
        fromDateTF.text = formatDate(fromDatePicker.date)
    }
    
    @objc private func toDateChanged() {
        toDateTF.text = formatDate(toDatePicker.date)
    }
    
    @objc private func doneFromDate() {
        fromDateTF.text = formatDate(fromDatePicker.date) // Fetch the current date from the picker
        fromDateTF.resignFirstResponder()
        triggerAPICallIfNeeded()
    }

    @objc private func doneToDate() {
        toDateTF.text = formatDate(toDatePicker.date) // Fetch the current date from the picker
        toDateTF.resignFirstResponder()
        triggerAPICallIfNeeded()
    }
    
    private func triggerAPICallIfNeeded() {
        guard let fromDateText = fromDateTF.text, !fromDateText.isEmpty,
              let toDateText = toDateTF.text, !toDateText.isEmpty else {
            return // Both dates must be selected to call the API
        }

        if let bioID = Constants.profileData.userData.first?.bioID,
           let campus = Constants.profileData.userData.first?.campus {
            presenter?.dutyRosterData(fromDate: fromDateText, toDate: toDateText, campus: campus, bioId: String(bioID))
            print("API Called: From Date: \(fromDateText), To Date: \(toDateText)")
        }
    }
    private func createToolbar(for selector: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: selector)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, doneButton], animated: false)
        return toolbar
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rosterData?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dutyRosterTableview.dequeueReusableCell(withIdentifier: "DutyRosterTableViewCell", for: indexPath) as! DutyRosterTableViewCell
        if let data = self.rosterData?.data[indexPath.row] {
            cell.nameLabel.text = data.empName
            cell.dutyScheduleLabel.text = "Scheduled for \(data.shift)"
            cell.dateLabel.text = data.date
            cell.dutyTimeLabel.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dutyRosterTableview.deselectRow(at: indexPath, animated: true)
    }
}

