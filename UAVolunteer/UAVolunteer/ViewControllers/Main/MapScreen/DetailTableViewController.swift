import UIKit
import FirebaseFirestore
import MessageUI
import SafariServices

class DetailTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet var table: UITableView!
    static var centerTitle: String?
    var request: CenterRequest?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard DetailTableViewController.centerTitle != nil else {
            showACError(text: "Cannot get string from title.")
            return
        }
        title = DetailTableViewController.centerTitle!
        getData(for: DetailTableViewController.centerTitle!)
    }

    func getData(for: String) {
        let database = Firestore.firestore()
        database.collection("centers").whereField("name", isEqualTo: DetailTableViewController.centerTitle!).getDocuments() {(snapshot, error) in
            if let error = error {
                self.showACError(text: error.localizedDescription)
                return
            } else {
                if let snapshot = snapshot, let firstDocument = snapshot.documents.first {
                    DispatchQueue.main.async {
                        self.request = CenterRequest(id: firstDocument.documentID,
                                                     description: firstDocument["description"] as! String,
                                                     name: firstDocument["name"] as! String,
                                                     email: firstDocument["email"] as! String,
                                                     business: firstDocument["business"] as! String,
                                                     type: firstDocument["type"] as! String)
                        self.table.reloadData()
                    }
                }
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        table.delegate = self
        table.dataSource = self
    }
    
    func sendEmail(recepient: [String], text: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(recepient)
            mail.setMessageBody(text, isHTML: false)
            
            present(UINavigationController(rootViewController: mail), animated: true, completion: nil)
        } else {
            guard let url = URL(string: "https://google.com/mail") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: (any Error)?) {
        controller.dismiss(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard request != nil else {
            return 0
        }
        return Mirror(reflecting: request!).children.count - 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailTableViewCell
        guard let request = request else {
            return cell
        }
            
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Business:"
            cell.detailLabel.text = request.business
        case 1:
            cell.titleLabel.text = "Type:"
            cell.detailLabel.text = request.type
        case 2:
            cell.titleLabel.text = "Email:"
            cell.detailLabel.text = request.email
        case 3:
            cell.titleLabel.text = "Description:"
            cell.detailLabel.text = "Click to see decription"
        default:
            break
        }
            
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DetailTableViewCell
        guard let request = request else {
            return
        }
        switch indexPath.row {
        case 0,2:
            self.sendEmail(recepient: [cell.detailLabel.text!], text: "")
        case 3:
            DescriptionInfoViewController.descriptionText = request.description
            self.pushVCTo(DescriptionInfoViewController.self)
        default:
            table.deselectRow(at: indexPath, animated: true)
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
