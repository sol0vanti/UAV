import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        detailView.alpha = 0
        detailView.layer.cornerRadius = 10.0
        detailView.layer.masksToBounds = true
        addAnnotation(50.44719232379335, 30.51071810176044, title: "Povernysʹ Zhyvym")
    }
    
    func addAnnotation(_ latitude: CLLocationDegrees, _ longtitude: CLLocationDegrees, title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        annotation.title = title
        
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        detailView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.detailView.alpha = 1
        }
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        UIView.animate(withDuration: 0.5) {
            self.detailView.alpha = 0
        }
        detailView.isHidden = true
    }
}
