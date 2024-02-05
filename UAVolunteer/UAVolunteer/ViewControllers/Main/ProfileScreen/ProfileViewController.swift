import UIKit
import Firebase

class ProfileViewController: UIViewController {
    @IBOutlet weak var accountType: UILabel!
    @IBOutlet weak var accountUsername: UILabel!
    @IBOutlet weak var accountLogo: UIImageView!
    @IBOutlet weak var passwordButton: CustomButton!
    @IBOutlet weak var accountButton: CustomButton!
    @IBOutlet weak var supportButton: CustomButton!
    @IBOutlet weak var secureButton: CustomButton!
    @IBOutlet weak var signoutButton: CustomButton!
    @IBOutlet weak var profileImageView: UIImageView!

    let defaults = UserDefaults.standard
    var request: [UserRequest]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0
        getAccountData()
        profileImageView.layer.cornerRadius = 75
        passwordButton.setIconImage(UIImage(systemName: "ellipsis.rectangle")!)
        accountButton.setIconImage(UIImage(systemName: "person.crop.circle")!)
        supportButton.setIconImage(UIImage(systemName: "phone.badge.waveform")!)
        secureButton.setIconImage(UIImage(systemName: "shield.lefthalf.filled")!)
        signoutButton.setIconImage(UIImage(systemName: "nosign")!)

        if let navigationController = navigationController {
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
            navigationItem.title = "My Profile"
            let settings = UIBarButtonItem(title: nil, image: UIImage(systemName: "gear"), target: self, action: #selector(settingsButtonClicked))
            navigationItem.rightBarButtonItems = [settings]
            navigationController.navigationBar.tintColor = .systemGray3
        }
    }
    
    func getAccountData(){
        let database = Firestore.firestore()
        database.collection("users").whereField("email", isEqualTo: defaults.string(forKey: "email")!).getDocuments() {(snapshot, error) in
            if error != nil {
                print(String(describing: error))
            } else {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.request = snapshot.documents.map { d in
                            return UserRequest(id: d.documentID, full_name: d["full_name"] as! String, account_creation_date: d["account_creation_date"] as! String, account_type: d["account_type"] as! String)
                        }
                        
                        guard self.request != nil else {
                            let ac = UIAlertController(title: "Error", message: "Cannot find your account, try again later.", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default) {_ in 
                                self.setVCTo(AccountViewController.self)
                            })
                            self.present(ac, animated: true)
                            return
                        }
                        
                        for request in self.request {
                            self.accountUsername.text = request.full_name
                            if request.account_type == "business" {
                                self.accountType.text = "Бізнес аккаунт"
                            } else if request.account_type == "user" {
                                self.accountType.text = "Користувач"
                            }
                        }
                        
                        self.view.alpha = 1
                    }
                }
            }
        }
    }
    
    @objc func settingsButtonClicked(){
        let ac = UIAlertController(title: "Settings", message: "Choose option:", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(ac, animated: true)
    }

    @IBAction func signoutDidTapped(_ sender: UIButton) {
        self.defaults.removeObject(forKey: "email")
        setVCTo(AccountViewController.self)
    }
}
