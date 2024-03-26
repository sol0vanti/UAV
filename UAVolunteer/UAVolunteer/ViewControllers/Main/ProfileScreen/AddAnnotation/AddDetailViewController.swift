import UIKit

class AddCenterDetailViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
    }
    
    @IBAction func continueButtonClicked(_ sender: UIButton) {
        let error = checkTextFields(errorLabel: errorLabel, textFields: [titleTextField, typeTextField, phoneTextField, emailTextField])
        
        guard error == nil else {
            showError(text: error!, label: errorLabel, textFields: [titleTextField, typeTextField, phoneTextField, emailTextField])
            return
        }
        
        defaults.set(titleTextField.text, forKey: "center-title")
        defaults.set(typeTextField.text, forKey: "center-type")
        defaults.set(phoneTextField.text, forKey: "center-phone")
        defaults.set(emailTextField.text, forKey: "center-email")
        defaults.set(descriptionTextView.text, forKey: "center-detail")
        
        defaults.set("detail-set", forKey: "center-set")
        
        self.pushVCTo(AddLogoViewController.self)
    }
}
