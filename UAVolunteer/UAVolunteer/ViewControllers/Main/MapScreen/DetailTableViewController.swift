import UIKit

class DetailTableViewController: UITableViewController {
    @IBOutlet var table: UITableView!
    static var centerTitle: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard DetailTableViewController.centerTitle != nil else {
            showACError(text: "Cannot get string from title.")
            return
        }
        getData(for: DetailTableViewController.centerTitle!)
    }
    
    func getData(for: String) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)

        return cell
    }
    
    func getData(forTitle: String) {
        
    }
}
