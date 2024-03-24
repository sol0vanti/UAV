import UIKit
import MapKit

class SelPlaceViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var pointSet = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.title = "Add Center"
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        mapView.addGestureRecognizer(longPressGesture)
        mapView.delegate = self
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                let point = gesture.location(in: mapView)
                let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                guard pointSet != true else {
                    mapView.removeAnnotations(mapView.annotations)
                    addAnnotation(at: coordinate)
                    return
                }
                pointSet = true
                addAnnotation(at: coordinate)
            }
        }
        
    func addAnnotation(at coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
}
