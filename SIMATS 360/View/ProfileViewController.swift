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
        guard let userData = data.data else {
            print("No profile data available")
            setDefaultProfileData()
            return
        }
        
        userNameLabel.text = userData.employeeName ?? "Not Available"
        bioIdLabel.text = "Bio Id: \(String(userData.bioID) ?? "N/A") \(userData.campus ?? "N/A")"
        designationLabel.text = "\(userData.category ?? "N/A")  \(userData.designationName ?? "N/A")"
        dojLabel.text = "DOJ: \(userData.doj ?? "N/A")"
        phoneLabel.text = userData.phone ?? "Not Available"
        mailLabel.text = userData.email ?? "Not Available"
        addressLabel.text = userData.address ?? "Not Available"
        
        internalExperienceLabel.text = "Saveetha Exp: \(userData.internalExperience ?? "N/A")"
        outsideExpLabel.text = "Outside Exp: \(userData.externalExperience ?? "N/A")"
        
        if !userData.profileImageURL.isEmpty {
            profileImg.loadImage(from: userData.profileImageURL)
        } else {
            profileImg.image = UIImage(named: "defaultProfileImage") // Fallback to a default image
        }
    }

    private func setDefaultProfileData() {
        userNameLabel.text = "Not Available"
        bioIdLabel.text = "Bio Id: N/A"
        designationLabel.text = "N/A"
        dojLabel.text = "DOJ: N/A"
        phoneLabel.text = "Not Available"
        mailLabel.text = "Not Available"
        addressLabel.text = "Not Available"
        internalExperienceLabel.text = "Saveetha Exp: N/A"
        outsideExpLabel.text = "Outside Exp: N/A"
        profileImg.image = UIImage(named: "defaultProfileImage") // Default image
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
        if let userData = Constants.profileData.userData?.first, let bioID = userData.bioID, let campus = userData.campus  {
            profilePresenter?.fetchProfile(bioId: String(bioID), campus: campus)
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
        let image = UIImage(named: "logo-tabbar")?.withRenderingMode(.alwaysOriginal) // Ensure the image is rendered
        let notificationButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(notificationTapped))
        
        notificationButton.tintColor = .clear
        
        
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
