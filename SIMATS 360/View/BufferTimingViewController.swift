//
//  BufferTimingViewController.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 21/10/24.
//

import UIKit

protocol BufferTimeViewProtocol: AnyObject {
    func showBufferTime(bufferResponse: BufferTimeModel)
    func showError(error: String)
}

class BufferTimingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BufferTimeViewProtocol {
    
    @IBOutlet weak var bufferDataTableview: UITableView!
    @IBOutlet weak var currentMonthLabel: UILabel!
    @IBOutlet weak var bufferTimeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bioIdLabel: UILabel!
  
    
    var bPresenter: BufferTimePresenterProtocol?
    var bufferTimeResponse: BufferTimeModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        bufferDataTableview.delegate = self
        bufferDataTableview.dataSource = self
        initNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let userData = Constants.profileData.userData.first {
            let date = Utils.getCurrentDateInYearMonthFormat()
            let yearMonth = date.split(separator: ":")
            
            bioIdLabel.text = "Bio Id: \(userData.bioID)"
            userNameLabel.text = userData.userName
            
            bPresenter?.fetchBufferTime(bioId: String(userData.bioID), campus: userData.campus, category: userData.category, year: String(yearMonth[0]), month: String(yearMonth[1]))
        }
    }
    
    func showBufferTime(bufferResponse: BufferTimeModel) {
        self.bufferTimeResponse = bufferResponse
        bufferTimeLabel.text = String(Int(bufferResponse.data.first?.adjustedBuffTime ?? 0))
        currentMonthLabel.text = "Minutes Available for \(Utils.getCurrentMonth()) month"
        DispatchQueue.main.async {
            self.bufferDataTableview.reloadData()
        }
    }
    
    func showError(error: String) {
        self.showAlert(title: "", message: error)
    }
    
    
    func initNavigationBar() {
        navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#F6F8F9"), titleColor: .black)
        navigationItem.title = "Buffer Time"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        let image = UIImage(named: "logo 2")
        let notificationButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(notificationTapped))
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 50, width: 30, height: 30)
        button.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItems = [notificationButton]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bufferTimeResponse?.data.first?.gsonData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bufferDataTableview.dequeueReusableCell(withIdentifier: "BufferTimeTableViewCell", for: indexPath) as! BufferTimeTableViewCell
        if let date = self.bufferTimeResponse?.data.first?.gsonData[indexPath.row].date ,let convertedDate = Utils.convertDateToMonthDay(dateString: date) {
            cell.currentMonthlabel.text = convertedDate
        }
        if let earlyTime = self.bufferTimeResponse?.data.first?.gsonData[indexPath.row].early, let exceedTime = self.bufferTimeResponse?.data.first?.gsonData[indexPath.row].exceed,let remainingBufferTime = self.bufferTimeResponse?.data.first?.gsonData[indexPath.row].remainingBuff  {
            var timing = ""
            var earlyTiming = ""
            if  exceedTime > 0 {
                timing = "Late By \(Int(exceedTime)) minutes"
            }
            if earlyTime > 0 {
                earlyTiming = ", Pre Exit by \(earlyTime) minutes"
            }
            cell.lateLabel.text = "\(timing) \(earlyTiming) \n Balance: \(Int(remainingBufferTime)) "
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
   
    @objc func notificationTapped() {
        print("Right button tapped")
       
    }
}

