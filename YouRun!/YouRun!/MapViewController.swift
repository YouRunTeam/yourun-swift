//
//  MapViewController.swift
//  YouRun!
//
//  Created by Anna Bartlett on 7/30/18.
//  Copyright © 2018 Anna Bartlett. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    private let locationManager = CLLocationManager()
    
    // appDelegate to enable Model sharing between VCs
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Models to share between VCs
    var runPrefs: runPrefsModel!
    var server: serverModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runPrefs = appDelegate.runPrefs
        server = appDelegate.server
        
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.requestWhenInUseAuthorization()

        mapView.settings.scrollGestures = true // pan camera
        mapView.settings.zoomGestures = true // tap/pinch to zoom
                                             /* PINCH NOT WORKING */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// from https://www.raywenderlich.com/179565/google-maps-ios-sdk-tutorial-getting-started
// get user location with an extention to MapViewController
extension MapViewController: CLLocationManagerDelegate {

    // grant or revoke permission to access location of user
    // (appears as popup - see Custom iOS Target Properties)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }

        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true // show user location
        mapView.settings.myLocationButton = true // button to center on user location
        mapView.settings.compassButton = true // compass to orient map when bearing is non-zero
    }
    
    // execute when locationManager receives new location data
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // center camera view on user location
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        // only get user location once (don't follow around)
        locationManager.stopUpdatingLocation()
        
        let marker = GMSMarker(position: location.coordinate)
        marker.title = "You are here!"
        marker.map = mapView
        
        let destinationPosition = CLLocationCoordinate2D(latitude: location.coordinate.latitude + 0.01, longitude: location.coordinate.longitude + 0.01)
        let destinationMarker = GMSMarker(position: destinationPosition)
        destinationMarker.title = "Turnaround Destination:"
        destinationMarker.snippet = "This is your halfway point!"
        destinationMarker.map = mapView
        
        let runPath = GMSMutablePath()
        runPath.add(location.coordinate)
        runPath.add(CLLocationCoordinate2D(latitude: location.coordinate.latitude + 0.005, longitude: location.coordinate.longitude))
        runPath.add(destinationPosition)
        let polyline = GMSPolyline(path: runPath)
        polyline.strokeColor = .green
        
        polyline.map = mapView 
    }
}
