import UIKit
import PhotosUI
import FirebaseFirestore
import FirebaseStorage

class AddLogoViewController: UIViewController, PHPickerViewControllerDelegate {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    var logo: UIImage?
    let defaults = UserDefaults.standard
    
//    var id: String
//    var address: String
//    var contact_phone: String
//    var description: String
//    var latitude: String
//    var longitude: String
//    var name: String
//    var website: String

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
    }
    
    func uploadDataToFirebase(logoSet: Bool) {
        let db = Firestore.firestore()
        if logoSet {
            if let centerDictionary = defaults.dictionary(forKey: "center-dictionary") as? [String: String] {
                db.collection("centers").addDocument(data: ["name": centerDictionary["center-title"]!, "type": centerDictionary["center-type"]!, "phone": centerDictionary["center-phone"]!, "email": centerDictionary["center-email"]!, "description": centerDictionary["center-description"]!, "longitude": self.defaults.string(forKey: "center-longitude")!, "latitude": self.defaults.string(forKey: "center-latitude")!, "business": self.defaults.string(forKey: "email")!, "logo-set": true]) { (error) in
                    if error != nil {
                        self.showACError(text: "Failed to save center dictionary.")
                        return
                    } else {
                        self.defaults.removeObject(forKey: "center-dictionary")
                        self.defaults.removeObject(forKey: "center-laitude")
                        self.defaults.removeObject(forKey: "center-longitude")
                        self.defaults.set(nil, forKey: "center-set")
                        self.tabBarController?.tabBar.isHidden = false
                        self.setVCTo(ProfileViewController.self)
                    }
                }
            }
        } else {
            if let centerDictionary = defaults.dictionary(forKey: "center-dictionary") as? [String: String] {
                db.collection("centers").addDocument(data: ["name": centerDictionary["center-title"]!, "type": centerDictionary["center-type"]!, "phone": centerDictionary["center-phone"]!, "email": centerDictionary["center-email"]!, "description": centerDictionary["center-description"]!, "longitude": self.defaults.string(forKey: "center-longitude")!, "latitude": self.defaults.string(forKey: "center-latitude")!, "business": self.defaults.string(forKey: "email")!, "logo-set": false]) { (error) in
                    if error != nil {
                        self.showACError(text: "Failed to save center dictionary.")
                        return
                    } else {
                        self.defaults.removeObject(forKey: "center-dictionary")
                        self.defaults.removeObject(forKey: "center-laitude")
                        self.defaults.removeObject(forKey: "center-longitude")
                        self.defaults.set(nil, forKey: "center-set")
                        self.tabBarController?.tabBar.isHidden = false
                        self.setVCTo(ProfileViewController.self)
                    }
                }
            }
        }
    }
    
    func uploadImageToFirebase() {
        let storage = Storage.storage()
        guard let imageData = logo!.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        if let centerDictionary = defaults.dictionary(forKey: "center-dictionary") as? [String: String] {
            let storageRef = storage.reference().child("center-logo").child(centerDictionary["center-title"]!)
            _ = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    self.showACError(text: "Error uploading image: \(error.localizedDescription)")
                    return
                } else {
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            self.showACError(text: "Error getting download URL: \(error.localizedDescription)")
                            return
                        } else {
                            let ac = UIAlertController(title: "Success", message: "You have successfully uploaded profile picture. Restart the app to see it.", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(ac, animated: true)
                        }
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
                    self.uploadDataToFirebase(logoSet: true)
                    self.uploadImageToFirebase()
                }
            }
        }
    }
    
    @IBAction func addClicked(_ sender: UIButton) {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        let phPickerVC = PHPickerViewController(configuration: config)
        phPickerVC.delegate = self
        self.present(phPickerVC, animated: true)
    }
    
    @IBAction func skipClicked(_ sender: UIButton) {
        uploadDataToFirebase(logoSet: false)
    }
}
