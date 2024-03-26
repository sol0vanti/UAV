import UIKit

class AddLogoViewController: UIViewController {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    /*
    var latitude: String!
    var longitude: String!
    var titleString: String!
    var typeString: String!
    var emailString: String!
    var numberString: String!
    var descriptionString: String!
    */

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
    }
}
