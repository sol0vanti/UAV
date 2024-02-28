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
        database.collection("locations").whereField("business", isEqualTo: defaults.string(forKey: "email")!).getDocuments() {(snapshot, error) in
            if error != nil {
                self.showACError(text: String(describing: error))
                return
            } else {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.requests = snapshot.documents.map { d in
                            return VolunteerListRequest(id: d.documentID, name: d["name"] as! String, address: d["address"] as! String, business: d["business"] as! String)}
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
        cell.cellAddress.text = request.address
        cell.cellimage.backgroundColor = .systemRed
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
