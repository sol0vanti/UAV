import UIKit
import MapKit

class AddSelPlaceViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    var pointSet = false
    let defaults = UserDefaults.standard
    var annotationCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        mapView.addGestureRecognizer(longPressGesture)
        mapView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash.circle.fill"), style: .plain, target: self, action: #selector(exitButtonClicked))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        guard defaults.string(forKey: "center-set") == "init" else {
            tabBarController!.tabBar.isHidden = true
            if defaults.string(forKey: "center-set") == "coordinate-set" {
                self.pushVCTo(AddCenterDetailViewController.self)
            } else if defaults.string(forKey: "center-set") == "detail-set" {
                self.pushVCTo(AddLogoViewController.self)
            }
            return
        }
    }
    
    @objc func exitButtonClicked() {
        tabBarController?.tabBar.isHidden = false
        self.defaults.removeObject(forKey: "center-dictionary")
        self.defaults.removeObject(forKey: "center-laitude")
        self.defaults.removeObject(forKey: "center-longitude")
        self.defaults.set(nil, forKey: "center-set")
        setVCTo(ProfileViewController.self)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                let point = gesture.location(in: mapView)
                let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                print(coordinate)
                guard pointSet != true else {
                    mapView.removeAnnotations(mapView.annotations)
                    addAnnotation(at: coordinate)
                    return
                }
                pointSet = true
                resetButton.isEnabled = true
                continueButton.isEnabled = true
                addAnnotation(at: coordinate)
            }
        }
        
    func addAnnotation(at coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "New Center"
        annotationCoordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func resetButtonClicked(_ sender: UIButton) {
        mapView.removeAnnotations(mapView.annotations)
        pointSet = false
        resetButton.isEnabled = false
        continueButton.isEnabled = false
    }
    
    @IBAction func continueButtonClicked(_ sender: UIButton) {
        self.defaults.set(annotationCoordinate?.latitude, forKey: "center-latitude")
        self.defaults.set(annotationCoordinate?.longitude, forKey: "center-longitude")
        self.defaults.set("coordinate-set", forKey: "center-set")
        pushVCTo(AddCenterDetailViewController.self)
    }
}
