//
//  MultiColorPolyLineSegment.swift
//  MoonRunner
//
//  Created by Kaira Diagne on 11-01-17.
//  Copyright © 2017 Zedenem. All rights reserved.
//

import UIKit
import MapKit

class MultiColorPolyLineSegment: MKPolyline {

    var color: UIColor?
    
    // Here we define the three colors you'll use for slow, medium and fast polyline segments.
    // Each color, in turn has its own RGB components. The slowest components will be completely red, 
    // the middle will be yellow and the fastest will be green. Everything else will be a blend of the two
    // nearest colors.
    class func colorSegments(forLocations locations: [Location]) -> [MultiColorPolyLineSegment] {
        var colorSegments: [MultiColorPolyLineSegment] = []
        
        // RGB for Red (slowest
        let red = (r: 1.0, g: 20.0 / 255.0, b: 44.0 / 255.0)
        
        // RGB for Yellow (middle)
        let yellow = (r: 1.0, g: 215.0 / 255.0, b: 0.0)
        
        // RGB for Green (fastest)
        let green  = (r: 0.0, g: 146.0 / 255.0, b: 78.0 / 255.0)
        
        let (speeds, minSpeed, maxSpeed) = allSpeeds(forLocations: locations)
        
        // now knowing the slowest + fastest, we can get mean too
        let meanSpeed = (minSpeed + maxSpeed) / 2
        
        // In this loop, we determine the value of each pre-calculated speed, relative to the full range of speed. 
        // This ratio then determines the UIColor to apply to the segment
        for i in 1..<locations.count {
            let l1 = locations[i-1]
            let l2 = locations[i]
            
            var coords: [CLLocationCoordinate2D] = []
            
            coords.append(CLLocationCoordinate2D(latitude: l1.latitude, longitude: l1.longitude))
            coords.append(CLLocationCoordinate2D(latitude: l2.latitude, longitude: l2.longitude))
            
            let speed = speeds[i-1]
            var color = UIColor.black
            
            if speed < minSpeed { // Between Red & Yellow
                let ratio = (speed - minSpeed) / (meanSpeed - minSpeed)
                let r = CGFloat(red.r + ratio * (yellow.r - red.r))
                let g = CGFloat(red.g + ratio * (yellow.g - red.g))
                let b = CGFloat(red.r + ratio * (yellow.r - red.r))
                color = UIColor(red: r, green: g, blue: b, alpha: 1)
            } else { // Between Yellow & Green
                let ratio = (speed - meanSpeed) / (maxSpeed - meanSpeed)
                let r = CGFloat(yellow.r + ratio * (green.r - yellow.r))
                let g = CGFloat(yellow.g + ratio * (green.g - yellow.g))
                let b = CGFloat(yellow.b + ratio * (green.b - yellow.b))
                color = UIColor(red: r, green: g, blue: b, alpha: 1)
            }
            
            let segment = MultiColorPolyLineSegment(coordinates: &coords, count: coords.count)
            segment.color = color
            colorSegments.append(segment)
        }
        
        return colorSegments
    }
    

    private class func allSpeeds(forLocations locations: [Location]) -> (speeds: [Double], minSpeed: Double, maxSpeed: Double) {
        // Make array for all speeds. Find the slowest and the fastes
        var speeds: [Double] = []
        var minspeed = DBL_MAX
        var maxspeed = 0.0
        
        for i in 1..<locations.count {
            let l1 = locations[i-1]
            let l2 = locations[i]
            
            let cl1 = CLLocation(latitude: l1.latitude, longitude: l1.longitude)
            let cl2 = CLLocation(latitude: l2.latitude, longitude: l2.longitude)
            
            let distance = cl2.distance(from: cl1)
            let time = l2.timestamp.timeIntervalSince(l1.timestamp)
            // Distance divided by time equals speed.
            let speed = distance / time
            
            minspeed = min(minspeed, speed)
            maxspeed = max(maxspeed, speed)
            
            speeds.append(speed)
        }
        
        return (speeds, minspeed, maxspeed)
    }
    
}
