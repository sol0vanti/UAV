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
        
        let centerDictionary = ["center-title": titleTextField.text, "center-type": typeTextField.text, "center-phone": phoneTextField.text, "center-email": emailTextField.text, "center-description": descriptionTextView.text]
        defaults.set(centerDictionary, forKey: "center-dictionary")
        defaults.set("detail-set", forKey: "center-set")
        
        self.pushVCTo(AddLogoViewController.self)
    }
}
