import UIKit
import AuthenticationServices
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import Firebase

class AccountViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @IBOutlet weak var yahooButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var icloudButton: UIButton!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard defaults.string(forKey: "email") == nil else {
            setVCTo(MainTabBarController.self)
            return
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let email = appleIDCredential.email
            let db = Firestore.firestore()
            db.collection("users").addDocument(data: ["idToken": appleIDCredential, "uid": userIdentifier]) { (error) in
                if error != nil {
                    let ac = UIAlertController(title: "Помилка", message: "Помилка сервера. Спробуйте ще раз пізніше.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "ОК", style: .default))
                    self.present(ac, animated: true)
                    return
                }
            }
            self.defaults.set(email, forKey: "email")
            setVCTo(MainTabBarController.self)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple ID authorization error: \(error.localizedDescription)")
        let ac = UIAlertController(title: "Помилка", message: "iCloud сервіси наразі не працюють. Спробуйте ще раз пізніше.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ОК", style: .default))
        self.present(ac, animated: true)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    
    @IBAction func icloudButtonClicked(_ sender: UIButton) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
            
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @IBAction func googleButtonClicked(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else {
                return
            }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            self.defaults.set(idToken, forKey: "idToken")
            self.setVCTo(MainTabBarController.self)
        }
    }
    
    @IBAction func yahooButtonClicked(_ sender: UIButton) {
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
}
