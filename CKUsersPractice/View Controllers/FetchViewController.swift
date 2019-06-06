//
//  FetchViewController.swift
//  CKUsersPractice
//
//  Created by Dustin Koch on 6/5/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import UIKit

class FetchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserController.shared.fetchCurrentUser { (success) in
            if success {
                DispatchQueue.main.async {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyBoard.instantiateViewController(withIdentifier: "navController")
                    UIApplication.shared.windows.first?.rootViewController = viewController
                }
            } else {
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toSignUp", sender: nil)
                }
            }
        }
    }

}//END OF CLASS
