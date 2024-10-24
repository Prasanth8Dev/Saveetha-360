//
//  SwapDutyViewController.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 09/10/24.
//

import UIKit

class SwapDutyViewController: UIViewController {

    @IBOutlet weak var bioIdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        loadUserData()
        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
