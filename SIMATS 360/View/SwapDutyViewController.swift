//
//  SwapDutyViewController.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 09/10/24.
//

import UIKit
protocol SwapDutyViewControllerProtocol: AnyObject {
    func showMessage(message: String)
}

class SwapDutyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,SwapDutyViewControllerProtocol {

    @IBOutlet weak var bioIdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    var groupResponse: GroupResponseModel?
    var pendingDuty: [Result]?
    var selectedDutyId = ""
    var selectedBioId = ""
    
    @IBOutlet weak var employeeListTF: UITextField!
    @IBOutlet weak var dutyPendingTF: UITextField!
    let pickerView = UIPickerView()
    var swapPresenter: SwapDutyPresenterProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        loadUserData()
        createToolbar()
        pickerView.delegate = self
        pickerView.dataSource = self
        employeeListTF.inputView = pickerView
        dutyPendingTF.inputView = pickerView
        
        if let data = pendingDuty, data.isEmpty {
            dutyPendingTF.isUserInteractionEnabled = false
        }
        if let data = groupResponse?.data.employeeOptions, data.isEmpty {
            employeeListTF.isUserInteractionEnabled = false
        }
        // Do any additional setup after loading the view.
    }
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        employeeListTF.inputAccessoryView = toolbar
        dutyPendingTF.inputAccessoryView = toolbar
        
    }
    
    func showMessage(message: String) {
        if message.lowercased().contains("successfully") {
            self.showAlertWithCompletion(title: "", message: message) {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.showAlert(title: "", message: message)
        }
       
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    @IBAction func requestTapped(_ sender: Any) {
        guard let date = dutyPendingTF.text, !date.isEmpty, let employee = employeeListTF.text, !employee.isEmpty,!selectedBioId.isEmpty, !selectedDutyId.isEmpty else {
            self.showAlert(title: "", message: "Kindly choose all the fields")
            return
        }
        if let bioId = Constants.profileData.userData.first?.bioID {
            swapPresenter?.swapDutyRequest(reqFromId: String(bioId), reqToId: selectedBioId, dutyId: selectedDutyId)
        }
        
    }
    
    private func loadUserData() {
        if let name = Constants.profileData.userData.first?.userName, let bioId = Constants.profileData.userData.first?.bioID {
            userNameLabel.text = name
            bioIdLabel.text = "Bio ID: \(bioId)"
        }
    }
    func initNavigationBar() {
        navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#F6F8F9"), titleColor: .black)
        navigationItem.title = "Swap Duty"
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if employeeListTF.isFirstResponder {
            return 1
        } else if dutyPendingTF.isFirstResponder {
            return 1
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if employeeListTF.isFirstResponder {
            return groupResponse?.data.employeeOptions.count ?? 0
        } else if dutyPendingTF.isFirstResponder {
            return pendingDuty?.count ?? 0
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if employeeListTF.isFirstResponder {
            selectedBioId = "\(groupResponse?.data.employeeOptions[row].bioID ?? 0)"
            employeeListTF.text = "\(groupResponse?.data.employeeOptions[row].name ?? "") - \(groupResponse?.data.employeeOptions[row].bioID ?? 0)"
            return  "\(groupResponse?.data.employeeOptions[row].name ?? "") - \(groupResponse?.data.employeeOptions[row].bioID ?? 0)"
        } else if dutyPendingTF.isFirstResponder {
            selectedDutyId = "\(pendingDuty?[row].dutyID ?? 0)"
            dutyPendingTF.text = "\(pendingDuty?[row].startdate ?? "")"
            return pendingDuty?[row].startdate
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if employeeListTF.isFirstResponder {
            employeeListTF.text = "\(groupResponse?.data.employeeOptions[row].name ?? "") - \(groupResponse?.data.employeeOptions[row].bioID ?? 0)"
            
        } else if dutyPendingTF.isFirstResponder {
            dutyPendingTF.text = "\(pendingDuty?[row].startdate ?? "")"
            
        } else {
            
        }
    }
}