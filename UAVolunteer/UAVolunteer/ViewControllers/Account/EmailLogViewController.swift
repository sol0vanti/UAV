import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class EmailLogViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var logButton: UIButton!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logButtonClicked(_ sender: UIButton) {
        let error = General.checkTextFields(errorLabel: errorLabel, textFields: [emailField, passwordField])
                 
        guard error == nil else {
            General.showError(text: error!, label: errorLabel, textFields: [emailField,passwordField])
            return
        }
                 
        let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                General.showError(text: error!.localizedDescription, label: self.errorLabel, textFields: [self.emailField, self.passwordField])
            }
            else {
                let destVC = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                UserDefaults.resetStandardUserDefaults()
                self.defaults.set(self.emailField.text!, forKey: "email")
                self.navigationController?.setViewControllers([destVC], animated: true)
            }
        }
    }
}
