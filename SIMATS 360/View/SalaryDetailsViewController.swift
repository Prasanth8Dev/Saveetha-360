//
//  SalaryDetailsViewController.swift
//  SIMATS 360
//
//  Created by Admin - iMAC on 03/10/24.
//

import UIKit
protocol SalaryDetailsProtocol: AnyObject {
    func displaySalaryReports(_ reports: SalaryReportResponse)
    func showError(_ message: String)
}
class SalaryDetailsViewController: UIViewController, SalaryDetailsProtocol {
    
    @IBOutlet weak var bioIdLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var othersValue: UILabel!
    @IBOutlet weak var othersLabel: UILabel!
    
    @IBOutlet weak var basicSalaryLabel: UILabel!
    
    @IBOutlet weak var basicSalaryValue: UILabel!
    @IBOutlet weak var hraLabel: UILabel!
    @IBOutlet weak var daLabel: UILabel!
    @IBOutlet weak var esiLabel: UILabel!
    @IBOutlet weak var esiValue: UILabel!
    @IBOutlet weak var pfValue: UILabel!
    @IBOutlet weak var ccaValue: UILabel!
    @IBOutlet weak var hraValue: UILabel!
    @IBOutlet weak var daValue: UILabel!
    @IBOutlet weak var taValue: UILabel!
    @IBOutlet weak var taLabel: UILabel!
    @IBOutlet weak var deductionsValue: UILabel!
    @IBOutlet weak var ccaLabel: UILabel!
    @IBOutlet weak var pfLabel: UILabel!
    @IBOutlet weak var totalValue: UILabel!
    @IBOutlet weak var deductionsLabel: UILabel!
    
    var salaryDetailsPresenter: SalaryDetailsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Salary Details"
        if let userData = Constants.profileData.userData.first {
            salaryDetailsPresenter?.fetchSalaryDetails(bioId: String(userData.bioID))
            bioIdLabel.text = "Bio Id: \(String(userData.bioID))"
            userNameLabel.text = userData.userName
        }
    }
    
    func displaySalaryReports(_ reports: SalaryReportResponse) {
        if let salaryReportData = reports.salaryReportData.first {
            var earnings = salaryReportData.earningsBasicSalary + salaryReportData.earningsCCA + salaryReportData.earningsDA + salaryReportData.earningsHRA + salaryReportData.earningsOthers
            
            if let ta = salaryReportData.earningsTA {
                earnings += ta
            } else  {
                taLabel.isHidden = true
                taValue.isHidden = true
            }
            basicSalaryValue.text = "\(salaryReportData.earningsBasicSalary)"
            ccaValue.text = "\(salaryReportData.earningsCCA)"
            hraValue.text = "\(salaryReportData.earningsHRA)"
            daValue.text = "\(salaryReportData.earningsDA)"
            othersValue.text = "\(salaryReportData.earningsOthers)"
            deductionsValue.text = "-\(salaryReportData.deductionsDeductions)"
            earnings -= salaryReportData.deductionsDeductions
            totalValue.text = "\(earnings)"
            
            if let pf = salaryReportData.deductionsPF {
                pfValue.text = "-\(pf)"
            } else {
                pfLabel.isHidden = true
                pfValue.isHidden = true
            }
            if let esi = salaryReportData.deductionsESI, !esi.isEmpty {
                esiValue.text = "-\(esi)"
            } else {
                esiValue.isHidden = true
                esiLabel.isHidden = true
            }
            
        }
    }
    
    func showError(_ message: String) {
        self.showAlert(title: "", message: message)
    }
}
