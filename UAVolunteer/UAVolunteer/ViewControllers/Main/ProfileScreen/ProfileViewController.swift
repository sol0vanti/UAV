import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var passwordButton: CustomButton!
    @IBOutlet weak var accountButton: CustomButton!
    @IBOutlet weak var supportButton: CustomButton!
    @IBOutlet weak var secureButton: CustomButton!
    @IBOutlet weak var signoutButton: CustomButton!
    @IBOutlet weak var profileImageView: UIImageView!

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
