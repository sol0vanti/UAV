import UIKit
import AuthenticationServices
import Firebase

class AccountViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @IBOutlet weak var yahooButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var microsoftButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var icloudButton: UIButton!
    let defaults = UserDefaults.standard
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let db = Firestore.firestore()
            db.collection("users").addDocument(data: ["email": email!, "uid": userIdentifier]) { (error) in
                if error != nil {
                    let ac = UIAlertController(title: "Помилка", message: "Помилка сервера. Спробуйте ще раз пізніше.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "ОК", style: .default))
                    self.present(ac, animated: true)
                    return
                }
            }
            self.defaults.set(email, forKey: "email")
            let destVC = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            self.navigationController?.setViewControllers([destVC], animated: true)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard defaults.string(forKey: "email") == nil else {
            let destVC = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            self.navigationController?.setViewControllers([destVC], animated: true)
            return
        }
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
    }
    @IBAction func microsoftButtonClicked(_ sender: UIButton) {
    }
    @IBAction func twitterButtonClicked(_ sender: UIButton) {
    }
    @IBAction func yahooButtonClicked(_ sender: UIButton) {
    }
}
