//
//  ReportsViewController.swift
//  SIMATS 360
//
//  Created by Admin - iMAC on 01/10/24.
//
protocol ReportsViewProtocol: AnyObject {
    func displaySalaryReports(_ reports: SalaryReportModel)
    func showError(_ message: String) 
}

import UIKit

class ReportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ReportsViewProtocol {

    @IBOutlet weak var bioIdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var salaryReportTableView: UITableView! {
        didSet {
            salaryReportTableView.delegate = self
            salaryReportTableView.dataSource = self
        }
    }
    var reportsPresenter: ReportsPresenter?
    var salaryResponse: SalaryReportModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userData = Constants.profileData.userData.first {
            bioIdLabel.text = "Bio Id:\( String(userData.bioID))"
            userNameLabel.text =  userData.userName
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavigationBar()
        if let bioId = (Constants.profileData.userData.first?.bioID) {
            reportsPresenter?.fetchSalaryReports(bioId: String(bioId))
        }

    }
    func initNavigationBar() {
        navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#F6F8F9"), titleColor: .black)
        navigationItem.title = "Reports"
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.salaryResponse?.salaryReportData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = salaryReportTableView.dequeueReusableCell(withIdentifier: "SalaryReportTableViewCell", for: indexPath) as! SalaryReportTableViewCell
        if let date = self.salaryResponse?.salaryReportData[indexPath.row].period, let formattedDate = Utils.convertDateFormat(inputDate:date ), let salary = self.salaryResponse?.salaryReportData[indexPath.row].grossSalaryWithDeduction {
            cell.monthLabel.text = formattedDate
            cell.salaryLabel.text = "\(salary)"
        }
       
      
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        salaryReportTableView.deselectRow(at: indexPath, animated: true)
        let salaryDetailsVC = SalaryDetailsRouter.createModule()
        self.navigationController?.pushViewController(salaryDetailsVC, animated: true)
        //self.present(salaryDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func displaySalaryReports(_ reports: SalaryReportModel) {
        self.salaryResponse = reports
        if self.salaryResponse?.salaryReportData.count ?? 0 > 0 {
            salaryReportTableView.reloadData()
        }
    }
    
    func showError(_ message: String) {
        self.showAlert(title: "", message: message)
    }

}
