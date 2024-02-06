import UIKit
import Firebase
import PhotosUI
import FirebaseStorage

class ProfileViewController: UIViewController, PHPickerViewControllerDelegate {
    @IBOutlet weak var accountType: UILabel!
    @IBOutlet weak var accountUsername: UILabel!
    @IBOutlet weak var accountLogo: UIButton!
    @IBOutlet weak var passwordButton: CustomButton!
    @IBOutlet weak var accountButton: CustomButton!
    @IBOutlet weak var supportButton: CustomButton!
    @IBOutlet weak var secureButton: CustomButton!
    @IBOutlet weak var signoutButton: CustomButton!

    let defaults = UserDefaults.standard
    var request: [UserRequest]!
    var logo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0
        overrideUserInterfaceStyle = .dark
        accountLogo.layer.cornerRadius = accountLogo.frame.width / 2
        getAccountData()
        passwordButton.setIconImage(UIImage(systemName: "ellipsis.rectangle")!)
        accountButton.setIconImage(UIImage(systemName: "person.crop.circle")!)
        supportButton.setIconImage(UIImage(systemName: "phone.badge.waveform")!)
        secureButton.setIconImage(UIImage(systemName: "shield.lefthalf.filled")!)
        signoutButton.setIconImage(UIImage(systemName: "nosign")!)

        if let navigationController = navigationController {
            navigationItem.title = "My Profile"
            let settings = UIBarButtonItem(title: nil, image: UIImage(systemName: "gear"), target: self, action: #selector(settingsButtonClicked))
            navigationItem.rightBarButtonItems = [settings]
            navigationController.navigationBar.tintColor = .lightGray
        }
    }
    
    @objc func settingsButtonClicked(){
        let ac = UIAlertController(title: "Settings", message: "Choose option:", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(ac, animated: true)
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

    @IBAction func signoutDidTapped(_ sender: UIButton) {
        self.defaults.removeObject(forKey: "email")
        setVCTo(AccountViewController.self)
    }
    
    @IBAction func accountLogoDidTapped(_ sender: UIButton) {
        let ac = UIAlertController(title: "Set profile picture", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Choose from library", style: .default){ _ in
            var config = PHPickerConfiguration()
            config.selectionLimit = 1
            let phPickerVC = PHPickerViewController(configuration: config)
            phPickerVC.delegate = self
            self.present(phPickerVC, animated: true)
        })
        ac.addAction(UIAlertAction(title: "Delete profile picture", style: .destructive) { _ in
            
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func uploadImageToFirebase() {
        let storage = Storage.storage()
        guard let imageData = logo!.jpegData(compressionQuality: 0.8) else {
            return
        }
        let storageRef = storage.reference().child("logos").child(defaults.string(forKey: "email")!)
        _ = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
            } else {
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
            for result in results {
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    if let image = object as? UIImage {
                        self.logo = image
                        self.uploadImageToFirebase()
                    }
                }
            }
        }
}
