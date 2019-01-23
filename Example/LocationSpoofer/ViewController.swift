//
//  ViewController.swift
//  LocationSpoofer
//
//  Copyright © 2019 Buglife, Inc. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import LocationSpoofer

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Example App"
        
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(mapView.losp_constraintsToMatchFrameOfView(view))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Debug", style: .plain, target: self, action: #selector(debugButtonTapped))
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let startAddress = "1150 Lombard St, San Francisco"
        let endAddress = "950 Lombard St, San Francisco"
        Trip.getWithStartAddress(startAddress, endAddress: endAddress, duration: 10) { trip, error in
            guard let trip = trip else {
                self.losp_showAlert(title: "Oops! Something went wrong during geocoding.", message: String(describing: error))
                return
            }
            LocationSpoofer.shared.location = trip
            self.mapView.setRegion(MKCoordinateRegionForMapRect(trip.polyline.boundingMapRect), animated: true)
        }
    }
    
    @objc private func debugButtonTapped() {
        let vc = LocationDebugViewController()
        present(vc, animated: true)
    }
}

extension ViewController {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager didFailWithError: \(error)")
        losp_showAlert(title: "Oops! Something went wrong.")
    }
}

extension UIView {
    func losp_constraintsToMatchFrameOfView(_ view: UIView) -> [NSLayoutConstraint] {
        return [
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }
}

extension MKMultiPoint {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}

extension UIViewController {
    func losp_showAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
