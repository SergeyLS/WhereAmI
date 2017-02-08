//
//  MapRouteViewController.swift
//  WhereAmI
//
//  Created by Sergey Leskov on 2/8/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import MapKit

class MapRouteViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    var route: Route!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        loadMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func mapRegion() -> MKCoordinateRegion {
        let initialLoc = route.locations.firstObject as! Location
        
        var minLat = initialLoc.latitude
        var minLng = initialLoc.longitude
        var maxLat = minLat
        var maxLng = minLng
        
        let locations = route.locations.array as! [Location]
        
        for location in locations {
            minLat = min(minLat, location.latitude)
            minLng = min(minLng, location.longitude)
            maxLat = max(maxLat, location.latitude)
            maxLng = max(maxLng, location.longitude)
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: ((minLat + maxLat) / 2), longitude: ((minLng + maxLng) / 2))
        let span = MKCoordinateSpan(latitudeDelta: ((maxLat - minLat) * 1.1), longitudeDelta: ((maxLng - minLng) * 1.1))
        return MKCoordinateRegion(center: coordinate, span: span)
    }

    

    func loadMap() {
        if route.locations.count > 0 {
            
            // Set the map bounds
            mapView.region = mapRegion()
            
            // Create the lines on the map
            let colorSegments = MultiColorPolyLineSegment.colorSegments(forLocations: route.locations.array as! [Location])
            mapView.addOverlays(colorSegments)
            
        }
    }

    
 }



//==================================================
// MARK: - MKMapViewDelegate
//==================================================
extension MapRouteViewController: MKMapViewDelegate {
 
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
