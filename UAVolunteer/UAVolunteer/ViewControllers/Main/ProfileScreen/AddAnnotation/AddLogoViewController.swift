import UIKit

class AddLogoViewController: UIViewController {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
    }
}
