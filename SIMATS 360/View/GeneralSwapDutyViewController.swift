//
//  GeneralSwapDutyViewController.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 23/11/24.
//

import UIKit
protocol GeneralSwapDutyViewControllerProtocol {
    func getGropuData(_ data: GroupResponseModel)
    func showMessage(Str: String)
}

class GeneralSwapDutyViewController: UIViewController, GeneralSwapDutyViewControllerProtocol, UIPickerViewDelegate, UIPickerViewDataSource {
  
    @IBOutlet weak var dutyDateTF: UITextField!
    
    @IBOutlet weak var substitueTF: UITextField!
    var presenter: GeneralSwapDutyPresenterProtocol?
    let pickerView = UIPickerView()
    var generalDutyDates = [""]
    var groupData: GroupResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "General Swap Duty"
        if let generalDuty = Constants.generalDutyModel {
            generalDutyDates = generalDuty.generalDuties.map { $0.shiftDate }
        }
        fetchGroupData()
        pickerView.delegate = self
        pickerView.dataSource = self
        dutyDateTF.inputView = pickerView
        substitueTF.inputView = pickerView
        createToolbar()
    }

    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        dutyDateTF.inputAccessoryView = toolbar
        substitueTF.inputAccessoryView = toolbar
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    @IBAction func requestTapped(_ sender: Any) {
        
    }
    
    private func fetchGroupData() {
        if let bioId = Constants.profileData.userData?.first?.bioID, let campus = Constants.profileData.userData?.first?.campus {
            presenter?.fetchGroupOptions(bioId: String(bioId), campus: campus)
        }
    }
    
    func getGropuData(_ data: GroupResponseModel) {
        self.groupData = data
        pickerView.reloadAllComponents()
    }
    
    func showMessage(Str: String) {
        self.showAlert(title: "", message: Str)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if dutyDateTF.isFirstResponder {
            return generalDutyDates.count
        } else if substitueTF.isFirstResponder {
            return self.groupData?.data.employeeOptions.count ?? 0
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if dutyDateTF.isFirstResponder {
            dutyDateTF.text = generalDutyDates[row]
            return generalDutyDates[row]
        } else if substitueTF.isFirstResponder {
            substitueTF.text = self.groupData?.data.employeeOptions[row].name 
            return self.groupData?.data.employeeOptions[row].name // Adjust as per model
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if dutyDateTF.isFirstResponder {
            dutyDateTF.text = generalDutyDates[row]
        } else if substitueTF.isFirstResponder {
            substitueTF.text = self.groupData?.data.employeeOptions[row].name // Adjust as per model
        }
    }
}
