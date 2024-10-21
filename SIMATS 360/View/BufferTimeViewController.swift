////
////  BufferTimeViewController.swift
////  SIMATS 360
////
////  Created by Admin - iMAC on 07/10/24.
////
//
//import UIKit
//
//
//protocol BufferTimeViewProtocol: AnyObject {
//    func showBufferTime(bufferResponse: BufferTimeModel)
//    func showError(error: String)
//}
//
//class BufferTimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BufferTimeViewProtocol {
//
//    @IBOutlet weak var bufferDataTableview: UITableView!
//    @IBOutlet weak var currentMonthLabel: UILabel!
//    @IBOutlet weak var bufferTimeLabel: UILabel!
//    @IBOutlet weak var userNameLabel: UILabel!
//    @IBOutlet weak var bioIdLabel: UILabel!
//    //    @IBOutlet weak var bufferTimeTableview: UITableView!
////    @IBOutlet weak var bufferTimeLabel: UILabel!
////    @IBOutlet weak var currentMonthLabel: UILabel!
//    
//    var bPresenter: BufferTimePresenterProtocol?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        bufferTimeTableview.delegate = self
////        bufferTimeTableview.dataSource = self
//        // Do any additional setup after loading the view.
//        initNavigationBar()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        if let userData = Constants.profileData.userData.first {
//            let date = Utils.getCurrentDateInYearMonthFormat()
//            let yearMonth = date.split(separator: ":")
//            
//            bPresenter?.fetchBufferTime(bioId: String(userData.bioID), campus: userData.campus, category: userData.category, year: String(yearMonth[0]), month: String(yearMonth[1]))
//        }
//    }
//    
//    func showBufferTime(bufferResponse: BufferTimeModel) {
//        
//    }
//    
//    func showError(error: String) {
//        self.showAlert(title: "", message: error)
//    }
//    
//    
//    func initNavigationBar() {
//        navigationController?.navigationBar.updateNavigationBarAppearance(backgroundColor: UIColor(hex: "#F6F8F9"), titleColor: .black)
//        navigationItem.title = "Buffer Time"
//        self.navigationController?.navigationBar.isHidden = false
//        self.navigationController?.navigationBar.tintColor = .black
//        let image = UIImage(named: "logo 2")
//        let notificationButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(notificationTapped))
//        let button = UIButton(type: .custom)
//        button.setImage(image, for: .normal)
//        button.frame = CGRect(x: 0, y: 50, width: 30, height: 30)
//        button.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
//        self.navigationItem.rightBarButtonItems = [notificationButton]
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = bufferDataTableview.dequeueReusableCell(withIdentifier: "BufferTimeTableViewCell", for: indexPath) as! BufferTimeTableViewCell
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//        
//    }
//   
//    @objc func notificationTapped() {
//        print("Right button tapped")
//       
//    }
//}
