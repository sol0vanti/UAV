import UIKit
import AuthenticationServices
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import Firebase

class AccountViewController: UIViewController {
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard defaults.string(forKey: "email") == nil else {
            setVCTo(MainTabBarController.self)
            return
        }
    }
    
    @IBAction func googleButtonClicked(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else {
                return
            }
            guard let user = result?.user else {
                return
            }
            
            let userEmail = user.profile?.email
            self.defaults.set(userEmail!, forKey: "email")
            let db = Firestore.firestore()
            db.collection("users").whereField("email", isEqualTo: userEmail!).getDocuments() { (snapshot, error) in
                if error != nil {
                    self.showACError(text: "Error finding email for an account")
                }
                else {
                    if let snapshot = snapshot {
                        if snapshot.isEmpty {
                            db.collection("users").addDocument(data: ["email": "\(userEmail!)", "uid": user.userID!, "account_creation_date": "\(Date().string(format: "yyyy-MM-dd"))", "account_type": "user", "full_name": "\(user.profile?.name ?? "Анонім")"]) { (error) in
                                if error != nil {
                                    self.showACError(text: "Failed to save email on Google Sign-In")
                                    return
                                } else {
                                    self.setVCTo(MainTabBarController.self)
                                }
                            }
                        }
                        else {
                            self.setVCTo(MainTabBarController.self)
                        }
                    }
                }
            }
        }
    }
        
    
    
    @IBAction func otherButtonClicked(_ sender: UIButton) {
        pushVCTo(EmailSignViewController.self)
    }
}

extension UIViewController {
     func setVCTo(_ viewController: UIViewController.Type) {
        let destVC = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "\(viewController)")
        self.navigationController?.setViewControllers([destVC], animated: true)
    }
    
    func pushVCTo(_ viewController: UIViewController.Type){
        let destVC = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "\(viewController)")
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    func checkTextFields(errorLabel: UILabel, textFields: [UITextField], confirmationField: UITextField? = nil, passwordTextField: UITextField? = nil) -> String? {
        for textField in textFields {
            if textField.text!.count <= 2 {
                return "Refill the highlighted text fields."
            }
        }
        guard confirmationField != nil else { return nil }
        
        if confirmationField?.text != passwordTextField?.text {
            return "Your password does not match two times, please try again later"
        }
        return nil
    }
    
    func showError(text: String, label: UILabel, textFields: [UITextField]){
        label.isHidden = false
        label.text = text
        for textField in textFields {
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.systemPink.cgColor
        }
    }
    
    func showACError(text: String) {
        let ac = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
