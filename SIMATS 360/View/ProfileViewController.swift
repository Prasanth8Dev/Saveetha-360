//
//  ProfileViewController.swift
//  SIMATS 360
//
//  Created by Admin - iMAC on 01/10/24.
//

import UIKit

protocol ProfileViewProtocol: AnyObject {
    func displayProfileData(_ data: ProfileDataModel)
    func showError(_ message: String)
}


class ProfileViewController: UIViewController, ProfileViewProtocol {
    
    var profilePresenter: ProfilePresenterProtocol?
    
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bioIdLabel: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var dojLabel: UILabel!
    @IBOutlet weak var internalExperienceLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var outsideExpLabel: UILabel!
    
    func displayProfileData(_ data: ProfileDataModel) {
        
        if let data = data.data.first {
            userNameLabel.text = data.employeeName
            bioIdLabel.text = "ID: \(data.bioID) \(data.campus)"
            designationLabel.text = "\(data.category)  \(data.designationName)"
            dojLabel.text = "DOJ:\(Utils.formatDateString(data.doj))"
            internalExperienceLabel.text = "" //"Saveetha Exp: \()"
            phoneLabel.text = data.phone
            mailLabel.text = data.email
            addressLabel.text = data.address
            outsideExpLabel.text = ""
        }
        
    }
    
    func showError(_ message: String) {
        self.showAlert(title: "", message: "We are Facing some issue to Load the Profile. Please try again later.")
    }
    

    @IBOutlet weak var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.makeCircular()
        // Do any additional setup after loading the view.
    }
    
    private func fetchProfileData() {
        if let userData = Constants.profileData.userData.first {
            profilePresenter?.fetchProfile(bioId: String(userData.bioID), campus: userData.campus)
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initNavigationBar()
        fetchProfileData()
        title = "Profile"
    }
    
    func initNavigationBar() {
        navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#F6F8F9"), titleColor: .black)
        navigationItem.title = "Profile"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.tintColor = .black
        let image = UIImage(named: "logo 2")
        
        let notificationButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(notificationTapped))
        
        
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        
        button.frame = CGRect(x: 0, y: 50, width: 50, height: 50)
        
        button.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
       // self.navigationItem.rightBarButtonItems = [notificationButton]
        
    }
    
   
    @objc func notificationTapped() {
        print("Right button tapped")
       
    }

}
