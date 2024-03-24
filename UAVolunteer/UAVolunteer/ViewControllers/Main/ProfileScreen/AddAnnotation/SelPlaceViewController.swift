import UIKit
import MapKit

class SelPlaceViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    var pointSet = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.title = "Add Center"
        navigationController?.setNavigationBarHidden(true, animated: animated)
        resetButton.isEnabled = false
        continueButton.isEnabled = false
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
                resetButton.isEnabled = true
                continueButton.isEnabled = true
                resetButton.backgroundColor = .darkGray
                continueButton.backgroundColor = .white
                addAnnotation(at: coordinate)
            }
        }
        
    func addAnnotation(at coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Center"
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func resetButtonClicked(_ sender: UIButton) {
        mapView.removeAnnotations(mapView.annotations)
        pointSet = false
        resetButton.isEnabled = false
        continueButton.isEnabled = false
        continueButton.backgroundColor = .lightGray
        resetButton.backgroundColor = .clear
    }
    
    @IBAction func continueButtonClicked(_ sender: UIButton) {
        return
    }
}
