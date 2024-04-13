import UIKit
import MapKit
import Firebase

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?

    init(coordinate: CLLocationCoordinate2D, title: String?) {
        self.coordinate = coordinate
        self.title = title
    }
}

class MapScreenViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    let defaults = UserDefaults.standard
    var requests: [MapAnnotationRequest]!
    var centerTitle: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard defaults.string(forKey: "center-set") == nil else {
            let ac = UIAlertController(title: "Новий центр", message: "При попередньому заході у UAV - ви створювали новий волонтерський центр. Бажаете продовжити?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel){_ in
                self.defaults.removeObject(forKey: "center-dictionary")
                self.defaults.removeObject(forKey: "center-latitude")
                self.defaults.removeObject(forKey: "center-logitude")
                self.defaults.set(nil, forKey: "center-set")
            })
            ac.addAction(UIAlertAction(title: "Continue", style: .destructive){_ in
                self.tabBarController?.selectedIndex = 2
            })
            self.present(ac, animated: true)
            return
        }
        getAnnotationData()
    }
    
    func getAnnotationData(){
        mapView.removeAnnotations(mapView.annotations)
        let database = Firestore.firestore()
        database.collection("centers").getDocuments() {(snapshot, error) in
            if error != nil {
                self.showACError(text: String(describing: error))
                return
            } else {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.requests = snapshot.documents.map { d in
                            return MapAnnotationRequest(id: d.documentID, 
                                                        latitude: d["latitude"] as! String,
                                                        longitude: d["longitude"] as! String,
                                                        name: d["name"] as! String)
                        }
                        guard self.requests != nil else {
                            self.showACError(text: "Requests is nil")
                            return
                        }
                        
                        for request in self.requests {
                            let requestAnnotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(request.latitude)!, longitude: CLLocationDegrees(request.longitude)!), title: request.name)
                            self.addAnnotation(requestAnnotation)
                        }
                    }
                }
            }
        }
    }
    
    func setUpVC(){
        mapView.delegate = self
    }

    func addAnnotation(_ annotation: MKAnnotation) {
        mapView.addAnnotation(annotation)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? CustomAnnotation {
            centerTitle = annotation.title ?? ""
        }
        moreButton.isEnabled = true
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        centerTitle = ""
        moreButton.isEnabled = false
    }
    
    @IBAction func moreButtonClicked(_ sender: UIButton) {
        DetailTableViewController.centerTitle = centerTitle
        pushVCTo(DetailTableViewController.self)
    }
}
