import UIKit
import Firebase
import FirebaseAuth

class PasswordViewController: UIViewController {
    @IBOutlet weak var oldPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func saveClicked(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        
        var error = checkTextFields(errorLabel: errorLabel, textFields: [oldPasswordField, newPasswordField, confirmPasswordField], confirmationField: confirmPasswordField, passwordTextField: newPasswordField)
        
        guard error == nil else {
            showError(text: error!, label: errorLabel, textFields: [oldPasswordField,newPasswordField,confirmPasswordField])
            return
        }
        
        if let providerData = user?.providerData {
            for userInfo in providerData {
                if userInfo.providerID == "google.com" {
                    let ac = UIAlertController(title: "Fail", message: "You are logged in with Google", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default){_ in
                        return
                    })
                    self.present(ac, animated: true)
                    return
                        
                } else {
                    var credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: self.oldPasswordField.text!)

                    Auth.auth().currentUser?.reauthenticate(with: credential) { error, _  in
                        if let error = error {
                            self.showACError(text: "Failed to reauthenticate with credential")
                            return
                        } else {
                            Auth.auth().currentUser?.updatePassword(to: self.confirmPasswordField.text!) { (error) in
                                if let error = error {
                                    self.showACError(text: "Failed to update password to new password")
                                    return
                                } else {
                                    let ac = UIAlertController(title: "Success", message: nil, preferredStyle: .alert)
                                    ac.addAction(UIAlertAction(title: "OK", style: .default){_ in
                                        return
                                    })
                                    self.present(ac, animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
