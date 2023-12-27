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
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        let error = General.checkTextFields(errorLabel: errorLabel, textFields: [emailField], confirmationField: confirmField, passwordTextField: passwordField)
        guard error == nil else {
            General.showError(text: error!, label: errorLabel, textFields: [emailField, passwordField, confirmField])
            return
        }
                        
        let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if err != nil {
                General.showError(text: "Error creating user", label: self.errorLabel, textFields: [])
            } else {
                let db = Firestore.firestore()
                        
                db.collection("users").addDocument(data: ["email": email, "uid": result!.user.uid ]) { (error) in
                    if error != nil {
                        General.showError(text: "Error saving user data", label: self.errorLabel, textFields: [])
                    }
                    UserDefaults.resetStandardUserDefaults()
                    self.defaults.set(self.emailField.text!, forKey: "email")
                    let ac = UIAlertController(title: "Success", message: "Your account was successfuly created and now you are free to use it.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default){_ in
                        let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController")
                        self.navigationController?.setViewControllers([destVC], animated: true)
                    })
                    self.present(ac, animated: true)
                }
            }
        }
    }
}
