//
//  CrimeAnnotations.swift
//  SeniorDesign
//
//  Created by Justino Almazan on 4/7/19.
//  Copyright © 2019 Alberto Espinoza. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class CrimeAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var identifier = "Pin"
    var crimePhoto: UIImage! = nil
    init(coordinate: CLLocationCoordinate2D, title:String?, subtitle:String?){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
