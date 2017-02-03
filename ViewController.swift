//
//  ViewController.swift
//  WhereAmI
//
//  Created by Sergey Leskov on 2/2/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var cl = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cl.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

