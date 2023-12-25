//
//  EmailLogViewController.swift
//  UAVolunteer
//
//  Created by Alex Balla on 25.12.2023.
//

import UIKit

class EmailLogViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var logButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logButtonClicked(_ sender: UIButton) {
    }
}
