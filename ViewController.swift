//
//  ViewController.swift
//  Safer_City
//
//  Created by Jesus Almazan on 1/17/19.
//  Copyright © 2019 Justino Almazan. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBAction func changeRoute(_ sender: UIButton) {
    }
    @IBAction func typeInDest(_ sender: Any) {
    }
    
    //where safer city will initialize chicago location
    var coordinate2D = CLLocationCoordinate2DMake(41.889166, -87.644432)
    
    var camera = MKMapCamera()
    
    @IBOutlet weak var mapView: MKMapView!
    
    //instance method
    func updateMapRegion(rangeSpan:CLLocationDistance){
        let region = MKCoordinateRegion.init(center: coordinate2D, latitudinalMeters: rangeSpan, longitudinalMeters: rangeSpan)
        mapView.region = region
    }
    
    /* func updateMapCamera(heading:CLLocationDirection, altitude:CLLocationDistance){
        camera.centerCoordinate = coordinate2D
        camera.altitude = 5000
        camera.pitch = 30.0
        mapView.camera = camera
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMapRegion(rangeSpan: 100)
    }


}

//chicago: 41.892479, -87.1860369
