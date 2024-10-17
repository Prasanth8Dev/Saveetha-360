//
//  LoginViewController.swift
//  Saveetha 360
//
//  Created by Prasanth S on 14/10/24.
//

import UIKit
import Combine

protocol LoginViewProtocol: AnyObject {
   // var presenter: LoginPresenterProtocol? { get set }
    func displayLoginResult(_ message: String)
    func startLoader()
    func stopLoader()
}

class LoginViewController: UIViewController,LoginViewProtocol {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var bioIdTextField: UITextField!
    @IBOutlet weak var bioIdView: UIView!
    var presenter: LoginPresenterProtocol?
   // private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let bioId = bioIdTextField.text, !bioId.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            self.showAlert(title: "", message: "Kindly Fill All required Fields")
            return
        }
        self.view.startLoader()
        presenter?.login(email: bioId, password: password)
    }
    
    func displayLoginResult(_ message: String) {
        self.showAlert(title: "", message: message)
    }
    
    func startLoader() {
        self.view.startLoader()
    }
    
    func stopLoader() {
        self.view.stopLoader()
    }

}
