//
//  MapViewController.swift
//  UAVolunteer
//
//  Created by Alex Balla on 20.12.2023.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
}
