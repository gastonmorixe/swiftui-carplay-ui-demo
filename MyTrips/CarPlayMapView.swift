//
//  CarPlayMapView.swift
//  MyTrips
//
//  Created by Gaston Morixe on 11/15/24.
//  https://gist.github.com/nitrag/0f36adb8e85e5b8df992a22226c844a2

import Foundation
import CarPlay
import MapKit

class CarPlayMapView: UIViewController, CPMapTemplateDelegate {

    var mapView: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("loading the carplay mapview")

        let region = MKCoordinateRegion(
           center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
           span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )

        self.mapView = MKMapView(frame: view.bounds)
        self.mapView!.setRegion(region, animated: true)
        self.mapView!.showsUserLocation = true
        self.mapView!.setUserTrackingMode(.follow, animated: true)
        self.mapView!.overrideUserInterfaceStyle = .light

        self.mapView!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.mapView!)

        self.mapView!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.mapView!.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.mapView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.mapView!.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    func mapTemplateDidBeginPanGesture(_ mapTemplate: CPMapTemplate) {
        print("🚙🚙🚙🚙🚙 Panning")
    }
    
    func mapTemplate(_ mapTemplate: CPMapTemplate, panWith direction: CPMapTemplate.PanDirection) {
        print("🚙🚙🚙🚙🚙 Panning: \(direction)")
    }
}
