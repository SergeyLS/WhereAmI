//
//  MapViewController.swift
//  WhereAmI
//
//  Created by Sergey Leskov on 2/6/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

import MapKit
import CoreLocation


class MapViewController: UIViewController {

    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        
        _locationManager.delegate = self
        
        // We want the best and the most precise location readings, which also use more battery power
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // The activity type paramater will help the device save some power throughout the user's run
        // It will pause location updates when the user does not significantly move
        _locationManager.activityType = .fitness
        
        // Movement threshold for new events
        _locationManager.distanceFilter = 10.0
        
        return _locationManager
    }()
    
    var myLocation: CLLocation?
    
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsUserLocation = true
        
        //        // show artwork on map
        //        let artwork = Artwork(title: "King David Kalakaua",
        //                              locationName: "Waikiki Gateway Park",
        //                              discipline: "Sculpture",
        //                              coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        //
        //        mapView.addAnnotation(artwork)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showStatus(location: CLLocation)  {
        statusLabel.text = "Altitude: \(Int(location.altitude)). Speed = \(location.speed)"
    }
    
    
    @IBAction func startAction(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    
    
    @IBAction func stopAction(_ sender: UIButton) {
        locationManager.stopUpdatingLocation()
        
    }

    
    @IBAction func addPointAction(_ sender: UIButton) {
        if let myLocation = myLocation {
            let location = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
            let anotation = MKPointAnnotation()
            anotation.coordinate = location
            anotation.title = DateManager.dateAndTimeToString(date: Date())
            anotation.subtitle = "addPointAction"
            mapView.addAnnotation(anotation)
        }
    }
}





//==================================================
// MARK: - CLLocationManagerDelegate
//==================================================
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last!
        
        self.myLocation = location
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        
        showStatus(location: location)
        
    }
    
}


//==================================================
// MARK: - MKMapViewDelegate
//==================================================
extension MapViewController: MKMapViewDelegate {
 }
