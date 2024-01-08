import UIKit
import MapKit

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
    
    let povernysZhyvymAnnotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 50.44719232379335, longitude: 30.51071810176044), title: "Povernysʹ Zhyvym", desc: [
        ["title": "Адреса", "detail": "вул. Богдана Хмельницького, 32, офіс 41 м, Kyiv, 01030"],
        ["title": "Телефон", "detail": "+380956321700"],
        ["title": "Додаткова Інформація", "detail": "Немає"]
    ])

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVC()
        addAnnotation(povernysZhyvymAnnotation)
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
            weak var mapScreenDelegate: MapScreenDelegate?
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
