//
//  SignUpViewController.swift
//  CKUsersPractice
//
//  Created by Dustin Koch on 6/5/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: - Actions
    @IBAction func signUpTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text,
            usernameTextField.text != "",
            let firstName = firstNameTextField.text,
            firstNameTextField.text != "" else { return }
        
        UserController.shared.createNewUser(username: username, firstName: firstName) { (success) in
            if success {
                DispatchQueue.main.async {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyBoard.instantiateViewController(withIdentifier: "navController")
                    UIApplication.shared.windows.first?.rootViewController = viewController
                }
            } else {
                //handle error
            }
        }
    }
}//END OF CLASS
