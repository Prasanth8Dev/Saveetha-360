//
//  ClaimsViewController.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 09/10/24.
//

import UIKit
protocol ClaimsViewControllerProtocol {
    func showMessage(_ message: String)
}

class ClaimsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, ClaimsViewControllerProtocol {

    @IBOutlet weak var bioIdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var claimsEncashmentsView: UIView!
    
    @IBOutlet weak var claimsCountLabel: UILabel!
    @IBOutlet weak var claimsLeaveView: UIView!

    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    
    var claimsData: ClaimsDataModel?
    let pickerView = UIPickerView()
    var claimsPresenter: ClaimsPresenterProtocol?
    var selectedClaims = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        loadUserData()
        initPickerView()
        setupTapAction()
        resetImages()
        createToolbar()
      
        // Do any additional setup after loading the view.
    }
    private func resetImages() {
        img1.image = UIImage(named: "Frame (3)")
        img2.image = UIImage(named: "Frame (3)")
        img3.image = UIImage(named: "Frame (3)")
    }
    private func setupTapAction() {
        claimsEncashmentsView.addTap {
            self.resetImages()
            self.selectedClaims = "Encashment"
            self.img1.image = UIImage(named: "Frame (2)")
        }
        
        claimsLeaveView.addTap {
            self.resetImages()
            self.selectedClaims = "CL"
            self.img2.image = UIImage(named: "Frame (2)")
        }
    }
    @IBAction func submitTapped(_ sender: Any) {
        guard let choosedDate = dateTF.text, !choosedDate.isEmpty, !selectedClaims.isEmpty else {
            self.showAlert(title: "", message: "Kindly select date and claim type")
            return
        }
        if let bioId = Constants.profileData.userData.first?.bioID, let campus = Constants.profileData.userData.first?.campus, let dutyId = claimsData?.claimsData.first?.dutyID {
            claimsPresenter?.applyClaims(bioId: String(bioId), campus: campus, creditName: selectedClaims, dutyDate: choosedDate, dutyId: String(dutyId))
        }
        
    }
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        dateTF.inputAccessoryView = toolbar
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    private func initPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        dateTF.inputView = pickerView
    }
    
    func showMessage(_ message: String) {
        if message.lowercased().contains("successfully") {
            self.showAlertWithCompletion(title: "", message: message) {
                self.navigationController?.popViewController(animated: true)
            }
        } else  {
            self.showAlert(title: "", message: message)
        }
        
    }
    
    private func loadUserData() {
        if let name = Constants.profileData.userData.first?.userName, let bioId = Constants.profileData.userData.first?.bioID, let count = claimsData?.claimsData {
            userNameLabel.text = name
            bioIdLabel.text = "Bio ID: \(bioId)"
            claimsCountLabel.text = "Duty Claims: \(count.count)"
        }
    }
    
    func initNavigationBar() {
        navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#F6F8F9"), titleColor: .black)
        navigationItem.title = "Claims"
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
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if dateTF.isFirstResponder {
            return claimsData?.claimsData.count ?? 0
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if dateTF.isFirstResponder {
            dateTF.text = claimsData?.claimsData[row].startDate
            return claimsData?.claimsData[row].startDate
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if dateTF.isFirstResponder {
            dateTF.text = claimsData?.claimsData[row].startDate
        } else {
            dateTF.text = ""
        }
    }
}
