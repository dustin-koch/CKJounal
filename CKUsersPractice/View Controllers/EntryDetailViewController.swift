//
//  EntryDetailViewController.swift
//  CKUsersPractice
//
//  Created by Dustin Koch on 6/6/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    //MARK: - Landing pad
    var entry: Entry? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - ACtions
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
        titleTextField.text != "",
        let body = bodyTextView.text,
        bodyTextView.text != "",
            let image = entryImageView.image else { return }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        EntryController.shared.createNewEntry(title: title, body: body, image: image) { (success) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        titleTextField.text = ""
        bodyTextView.text = ""
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        entryImageView.image = entry.image
        titleTextField.text = entry.title
        bodyTextView.text = entry.body
    }

}//END OF VIEW CONTROLLER
