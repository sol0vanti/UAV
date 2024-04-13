import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class EmailSignViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        let error = checkTextFields(errorLabel: errorLabel, textFields: [emailField, confirmField, passwordField], confirmationField: confirmField, passwordTextField: passwordField)
        guard error == nil else {
            showError(text: error!, label: errorLabel, textFields: [emailField, passwordField, confirmField])
            return
        }
                        
        let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if err != nil {
                self.showError(text: "Error creating user", label: self.errorLabel, textFields: [])
            } else {
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["email": "\(email)", 
                                                          "uid": result!.user.uid,
                                                          "account_creation_date": "\(Date().string(format: "yyyy-MM-dd"))",
                                                          "account_type": "user",
                                                          "full_name": "\(email)"]) { (error) in
                    if error != nil {
                        self.showACError(text: "Failed to save data on Firebase server")
                        return
                    }
                    UserDefaults.resetStandardUserDefaults()
                    self.defaults.set(self.emailField.text!, forKey: "email")
                    let ac = UIAlertController(title: "Success", message: "Your account was successfuly created and now you are free to use it.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default){_ in
                        let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController")
                        self.navigationController?.setViewControllers([destVC], animated: true)
                    })
                    self.present(ac, animated: true)
                }
            }
        }
    }
    
    @IBAction func logButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let logInViewController = storyboard.instantiateViewController(withIdentifier: "EmailLogViewController") as? EmailLogViewController {
            navigationController?.pushViewController(logInViewController, animated: true)
        }
    }
}
