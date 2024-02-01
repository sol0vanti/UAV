import UIKit
import MapKit
import Firebase

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var desc: [[String: String]]?

    init(coordinate: CLLocationCoordinate2D, title: String?, desc: [[String: String]]?) {
        self.coordinate = coordinate
        self.title = title
        self.desc = desc
    }
}

class MapScreenViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    weak var mapScreenDelegate: MapScreenDelegate?
    let defaults = UserDefaults.standard
    var requests: [CenterRequest]!

    override func viewDidLoad() {
        super.viewDidLoad()
        getAnnotationData()
        setUpVC()
    }
    
    func getAnnotationData(){
        let database = Firestore.firestore()
        database.collection("locations").getDocuments() {(snapshot, error) in
            if error != nil {
                print(String(describing: error))
            } else {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.requests = snapshot.documents.map { d in
                            return CenterRequest(id: d.documentID, address: d["address"] as! String, contact_phone: d["contact_phone"] as! String, description: d["description"] as! String, latitude: d["latitude"] as! String, longitude: d["longitude"] as! String, name: d["name"] as! String, website: d["website"] as! String)
                        }
                        guard self.requests != nil else {
                            print("Requests is nil")
                            return
                        }
                        
                        for request in self.requests {
                            let requestAnnotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(request.latitude)!, longitude: CLLocationDegrees(request.longitude)!), title: request.name, desc: [
                                ["title": "Опис", "detail": "\(request.description)"],
                                ["title": "Адреса", "detail": "\(request.address)"],
                                ["title": "Телефон", "detail": "\(request.contact_phone)"],
                                ["title": "Веб-сайт", "detail": "\(request.website)"]
                            ])
                            self.addAnnotation(requestAnnotation)
                        }
                        self.mapScreenDelegate?.updateCollectionViewData()
                    }
                }
            }
        }
    }
    
    func setUpVC(){
        mapView.delegate = self
        detailView.alpha = 0
        detailView.layer.cornerRadius = 25.0
        detailView.layer.masksToBounds = true
    }

    func addAnnotation(_ annotation: MKAnnotation) {
        mapView.addAnnotation(annotation)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        detailView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.detailView.alpha = 1
        }
        if let selectedAnnotation = view.annotation as? CustomAnnotation {
            DetailViewController.centerName = selectedAnnotation.title
            DetailViewController.centerDetail = selectedAnnotation.desc
            mapScreenDelegate?.didSelectAnnotation(title: DetailViewController.centerName)
        
            print(DetailViewController.centerName ?? "Error: Cannot find 'DetailViewController.centerName'")
            print(DetailViewController.centerDetail ?? "Error: Cannot find 'DetailViewController.centerDetail'")
            mapScreenDelegate?.updateCollectionViewData()
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        UIView.animate(withDuration: 0.5) {
            self.detailView.alpha = 0
        }
        detailView.isHidden = true
    }
}
