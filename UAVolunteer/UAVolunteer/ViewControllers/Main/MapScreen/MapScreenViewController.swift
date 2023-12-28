import UIKit
import MapKit

// Create a class that conforms to MKAnnotation
class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?

    init(coordinate: CLLocationCoordinate2D, title: String?) {
        self.coordinate = coordinate
        self.title = title
    }
}

class MapScreenViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    let povernysZhyvymAnnotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 50.44719232379335, longitude: 30.51071810176044), title: "Povernysʹ Zhyvym")

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        detailView.alpha = 0
        detailView.layer.cornerRadius = 25.0
        detailView.layer.masksToBounds = true

        addAnnotation(povernysZhyvymAnnotation)
    }

    func addAnnotation(_ annotation: MKAnnotation) {
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

