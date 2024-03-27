import UIKit
import Firebase

class VolunteerListTableViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    let defaults = UserDefaults.standard
    var requests: [VolunteerListRequest]!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getBusinessData()
        table.delegate = self
        table.dataSource = self
    }
    
    func getBusinessData() {
        let database = Firestore.firestore()
        database.collection("centers").whereField("business", isEqualTo: defaults.string(forKey: "email")!).getDocuments() {(snapshot, error) in
            if error != nil {
                self.showACError(text: String(describing: error))
                return
            } else {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.requests = snapshot.documents.map { d in
                            return VolunteerListRequest(id: d.documentID, name: d["name"] as! String, business: d["business"] as! String)}
                        self.table.reloadData()
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard requests != nil else {
            return 0
        }
        return requests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VolunteerListTableViewCell", for: indexPath) as! VolunteerListTableViewCell
        let request = requests[indexPath.row]
        cell.cellTitle.text = request.name
        cell.cellimage.backgroundColor = .systemRed
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            let ac = UIAlertController(title: "Warning", message: "Whether you press 'Continue' the center will be deleted forever.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .destructive) { _ in
                tableView.beginUpdates()
                let request = self.requests[indexPath.row]
                let db = Firestore.firestore()
                db.collection("centers").whereField("name", isEqualTo: request.name).getDocuments { (querySnapshot, error) in
                    if error != nil {
                        self.showACError(text: "Unable to delete field. Try again later.")
                    } else {
                        for document in querySnapshot!.documents {
                            let documentRef = db.collection("centers").document(document.documentID)
                            documentRef.delete { error in
                                if error != nil {
                                    self.showACError(text: "Unable to delete field. Try again later.")
                                } else {
                                    self.requests.remove(at: indexPath.row)
                                    tableView.deleteRows(at: [indexPath], with: .fade)
                                    tableView.endUpdates()
                                    let ac = UIAlertController(title: "Success", message: "You have successfully removed field", preferredStyle: .alert)
                                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                                    self.present(ac, animated: true)
                                }
                            }
                        }
                    }
                }
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(ac, animated: true)
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
