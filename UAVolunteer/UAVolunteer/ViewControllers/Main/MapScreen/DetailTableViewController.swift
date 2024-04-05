import UIKit
import FirebaseFirestore

class DetailTableViewController: UITableViewController {
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard request != nil else {
            return 0
        }
        return Mirror(reflecting: request!).children.count - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailTableViewCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
