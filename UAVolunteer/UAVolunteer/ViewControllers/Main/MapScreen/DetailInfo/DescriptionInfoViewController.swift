import UIKit

class DescriptionInfoViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    static var descriptionText: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.text = DescriptionInfoViewController.descriptionText
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Description"
    }
}
