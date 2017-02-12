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
import UserNotifications
import CoreData


class MapViewController: UIViewController {
    
    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var addPointButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        
        _locationManager.delegate = self
        
        //_locationManager.requestWhenInUseAuthorization()
        
        _locationManager.requestAlwaysAuthorization()  //for Background
        
        // We want the best and the most precise location readings, which also use more battery power
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // The activity type paramater will help the device save some power throughout the user's run
        // It will pause location updates when the user does not significantly move
        //_locationManager.activityType = .fitness
        
        // Movement threshold for new events
        _locationManager.distanceFilter = 5.0
        
       _locationManager.allowsBackgroundLocationUpdates = true
        
        return _locationManager
    }()
    
    var myLocation: CLLocation?
    
    lazy var myLocations = [CLLocation]()
    
    lazy var timer = Timer()
    var seconds: Int64 = 0
    var distance: Int64 = 0
    var isStart = false
    var kilometers: Int64 = 0
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        mapView.delegate = self
        
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsUserLocation = true
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showButton()
        showPoints()
    }
    
    
    //==================================================
    // MARK: - func
    //==================================================
    
    func showStatus(location: CLLocation)  {
        statusLabel.text = "Altitude: \(Int(location.altitude))m. Speed = \(Int(location.speed*3600/1000))km/h"
    }
    
    
    
    func stopRoute() {
        locationManager.stopUpdatingLocation()
        statusLabel.text = "Stop"
        isStart = false
        showButton()
        
        timer.invalidate()
        
        
        for overlay in mapView.overlays {
            mapView.remove(overlay)
        }
    }
    
    
    func eachSecond(timer: Timer) {
        seconds += 1
        
        if let myLocation = myLocation {
            
            statusLabel.text = "Altitude: \(Int(myLocation.altitude))m. Speed = \(Int(myLocation.speed*3600/1000))km/h \n"
            statusLabel.text = statusLabel.text! + "Time: \(Int(seconds)) s. Distance: \(Int(distance)) m."
            
        }
        
        
        let km = Int64(distance/1000)
        
        if kilometers != km {
            
            kilometers = km
            
            scheduleNotification()
        }
        
    }
    
    
    func showButton()  {
        startButton.isEnabled = !isStart
        stopButton.isEnabled = isStart
        addPointButton.isEnabled = isStart
        saveButton.isEnabled = isStart
    }
    
    //==================================================
    // MARK: - @IBAction
    //==================================================
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        if !isStart {
            return
        }
        
        stopRoute()
        
        if let newRoute = Route(distance: Double(distance), duration: seconds)  {
            // Create locations array
            var savedLocations = [Location]()
            for location in self.myLocations {
                if let savedLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, timestamp: location.timestamp) {
                    savedLocations.append(savedLocation)
                }
            }
            newRoute.locations = NSOrderedSet(array: savedLocations)
            CoreDataManager.shared.saveContext()
        }
    }
    
    
    @IBAction func stopAction(_ sender: UIButton) {
        stopRoute()
    }
    
    func addPoint(title: String, subtitle:String, locationCoordinate2D: CLLocationCoordinate2D)  {
        let title = DateManager.dateAndTimeToString(date: Date())
        let subtitle = "addPointAction"
       
        let _anotation = MKPointAnnotation()
        _anotation.coordinate = locationCoordinate2D
        _anotation.title = title
        _anotation.subtitle = subtitle
        mapView.addAnnotation(_anotation)

    }
    
    
    @IBAction func addPointAction(_ sender: UIButton) {
        if let myLocation = myLocation {
            
            let title = DateManager.dateAndTimeToString(date: Date())
            let subtitle = "addPointAction"
            let locationCoordinate2D = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
            addPoint(title: title, subtitle: subtitle, locationCoordinate2D: locationCoordinate2D)
            
            if Point(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude, title: title, subtitle: subtitle) != nil {
                CoreDataManager.shared.saveContext()
            }
        }
    }
    
    
    @IBAction func startAction(_ sender: UIButton) {
        if isStart {
            return
        }
        
        isStart = true
        showButton()
        
        // Reset statistics
        seconds = 0
        distance = 0
        kilometers = 0
        myLocations.removeAll(keepingCapacity: false)
        
        // Configure Timer
        let updateSelector = #selector(eachSecond(timer:))
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: updateSelector, userInfo: nil, repeats: true)
        
        locationManager.startUpdatingLocation()
    }
    
    
    //==================================================
    // MARK: - Notification
    //==================================================
    func scheduleNotification(){
        let content = UNMutableNotificationContent()
        content.title = "1000 meters notification demo"
        content.subtitle = "Total distance = \(distance)"
        content.body =  "Good job!"
        content.badge = 1
        
        let request = UNNotificationRequest(identifier: "1000meters", content: content, trigger: nil)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request, withCompletionHandler: nil)
        notificationCenter.delegate = self
        
        
        
        UIApplication.shared.applicationIconBadgeNumber += 1
   }
    
    
}





//==================================================
// MARK: - CLLocationManagerDelegate
//==================================================
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        for location in locations {
            myLocation = location
            let howRecent = location.timestamp.timeIntervalSinceNow
            
            // If the devide isn't confident it has a reading within 20 meters of the user's actual location
            // It's best to keep it out of your dataset. This check is especially important at the start of the run
            // When the device starts narrowing down the general area of the user At this stage it is likely to update with some inaccurate
            // data for the first few points.
            if abs(howRecent) < 10 && location.horizontalAccuracy < 20 {
                // Update distance
                if self.myLocations.count > 0 {
                    // Calculate th distance between the last location and the current location
                    self.distance += Int64(location.distance(from: self.myLocations.last!))
                    
                    var coords: [CLLocationCoordinate2D] = []
                    coords.append(self.myLocations.last!.coordinate)
                    coords.append(location.coordinate)
                    
                    // The map always centers on the most recent location
                    let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
                    mapView.setRegion(region, animated: true)
                    
                    // Add little blue polylines to show the user's trail thus far
                    mapView.add(MKPolyline(coordinates: &coords, count: coords.count))
                }
                
                // Save location
                self.myLocations.append(location)
            }
        }
        
    }
    
    func showPoints()  {
        
        //removeAnnotations
        let annotationsToRemove = mapView.annotations
        mapView.removeAnnotations( annotationsToRemove )
        
        //new
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Point.type)
        request.predicate = NSPredicate(value: true)
        
        let resultsArray = (try? CoreDataManager.shared.viewContext.fetch(request)) as? [Point]
        
        if (resultsArray?.count)! > 0 {
            
            for point in resultsArray! {
                let title = point.title
                let subtitle = point.subtitle
                let locationCoordinate2D = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                addPoint(title: title, subtitle: subtitle, locationCoordinate2D: locationCoordinate2D)
                
            }
            
            
        }
        
        
    }
    
}


//==================================================
// MARK: - MKMapViewDelegate
//==================================================
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if !overlay.isKind(of: MKPolyline.self) {
            return MKOverlayRenderer()
        }
        
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}


//==================================================
// MARK: - UNUserNotificationCenterDelegate
//==================================================

extension MapViewController: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //print("Silently handle no notification")
        completionHandler([.alert,.sound])
    }
    
}
