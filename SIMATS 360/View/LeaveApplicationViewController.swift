//
//  LeaveApplicationViewController.swift
//  SIMATS 360
//
//  Created by Admin - iMAC on 04/10/24.
//

import UIKit
import FSCalendar

protocol LeaveApplicationViewControllerProtocol: AnyObject {
    func showResponse(message: String)
}

class LeaveApplicationViewController: UIViewController,LeaveApplicationViewControllerProtocol, UIPickerViewDelegate, UIPickerViewDataSource, FSCalendarDelegate, FSCalendarDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var bioIdLabel: UILabel!
    
    @IBOutlet weak var formUploadView: UIView!
    @IBOutlet weak var leaveCategory: UITextField!
    @IBOutlet weak var reasonTextView: UITextView! {
        didSet {
            reasonTextView.textColor = .lightGray
            reasonTextView.delegate = self
        }
    }
    
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var leaveTypeTextField: UITextField!
    
    @IBOutlet weak var leaveFormLabel: UILabel!
    
    @IBOutlet weak var leaveSessionTF: UITextField!
    var leaveApplyPresenter: LeaveApplyPresenterProtocol?
    let pickerView = UIPickerView()
    let typeOfLeave = ["Full Day", "Half Day"]
    let sessionTypes = ["session1","session2"]
    var selectedDate = ""
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        initPickerViewForTF()
        loadUserData()
        pickerView.delegate = self
        pickerView.dataSource = self
        //
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        formUploadView.addTap {
            self.openGallery()
        }
    }
    
    private func loadUserData() {
        if let userName = Constants.profileData.userData.first?.userName, let bioId = Constants.profileData.userData.first?.bioID {
            userNameLabel.text = userName
            bioIdLabel.text = "Bio Id: \(String(bioId))"
        }
    }
    
    @IBAction func imageUpload(_ sender: Any) {
        self.openGallery()
    }
    
    private func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary // Use .camera for camera access
        imagePicker.allowsEditing = true // Allow editing of selected images
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        self.applyLeave()
    }

    
    private func applyLeave() {
        guard let imageForm = selectedImage, !selectedDate.isEmpty, let leaveCat = leaveCategory.text, let leaveReason = reasonTextView.text, let leaveSession = leaveSessionTF.text, !leaveReason.isEmpty, !leaveSession.isEmpty, let bioId = Constants.profileData?.userData.first?.bioID, let campus = Constants.profileData.userData.first?.campus, let headId = Constants.profileData.userData.first?.headID,let leaveType = leaveTypeTextField.text, !leaveType.isEmpty else {
            self.showAlert(title: "", message: "Some fields are empty")
            return
        }
        let totaldays = leaveType.lowercased() == "full day" ? "1" : "0.5"
        let leaveT = leaveType.lowercased() == "full day" ? "full_day" : "half_day"
        let session = leaveType.lowercased() == "full day" ? "" : leaveSession
        let leaveCatgory = Utils.removeAfterAnyString(from: leaveCat, inputStr: "-")
        let param: [String : Any] = ["campus":campus,
                     "bioId":String(bioId),
                     "leaveCategory":leaveCatgory,
                    "leaveType": leaveT,
                     "totalDays":totaldays,
                     "headId": String(headId),
                     "reason":leaveReason,
                     "startDate":selectedDate,
                     "file":imageForm,
                     "daySession":session]
        leaveApplyPresenter?.applyLeave(param: param)
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            leaveFormLabel.text = "Image Added"
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            leaveFormLabel.text = "Image Added"
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func initPickerViewForTF() {
        leaveCategory.inputView = pickerView
        leaveTypeTextField.inputView = pickerView
        leaveSessionTF.inputView = pickerView
        createToolbar()
        
    }
    
    func initNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#F6F8F9"), titleColor: .black)
        navigationItem.title = "Leave Application"
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
    
    func showResponse(message: String) {
        self.showAlertWithCompletion(title: "", message: message) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reasonTextView.text == "Type in less than 30 words" {
            reasonTextView.text = ""
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = reasonTextView.text, text.isEmpty {
            reasonTextView.text = "Type in less than 30 words"
        }
    }
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        leaveCategory.inputAccessoryView = toolbar
        leaveTypeTextField.inputAccessoryView = toolbar
        leaveSessionTF.inputAccessoryView = toolbar
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
        if leaveTypeTextField.text?.lowercased() == "full day" {
            leaveSessionTF.isUserInteractionEnabled = false
            leaveSessionTF.text = "-"
        } else {
            leaveSessionTF.isUserInteractionEnabled = true
            leaveSessionTF.text =  leaveTypeTextField.text?.lowercased() == "half day" ? leaveSessionTF.text : ""
        }
    }
    
    // MARK: - UIPickerViewDataSource Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if leaveCategory.isFirstResponder {
            return Constants.availableLeaveTypes.count
        } else if leaveTypeTextField.isFirstResponder {
            return typeOfLeave.count
        } else if leaveSessionTF.isFirstResponder {
            return sessionTypes.count
        }
        return 0
    }
    
    // MARK: - UIPickerViewDelegate Methods
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if leaveCategory.isFirstResponder {
            leaveCategory.text = Constants.availableLeaveTypes[row]
            return Constants.availableLeaveTypes[row]
        } else if leaveTypeTextField.isFirstResponder {
            leaveTypeTextField.text = typeOfLeave[row]
            return typeOfLeave[row]
        } else if leaveSessionTF.isFirstResponder {
            leaveSessionTF.text = sessionTypes[row]
            return sessionTypes[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if leaveCategory.isFirstResponder {
            leaveCategory.text = Constants.availableLeaveTypes[row]
        } else if leaveTypeTextField.isFirstResponder {
            leaveTypeTextField.text = typeOfLeave[row]
        } else if leaveSessionTF.isFirstResponder {
            leaveSessionTF.text = sessionTypes[row]
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium // Change as needed
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDateString = dateFormatter.string(from: date)
        selectedDate = selectedDateString
        print("Selected date: \(selectedDateString)")
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("Deselected date: \(date)")
    }
}
