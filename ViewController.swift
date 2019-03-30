import UIKit
import MapKit
import CoreLocation

class MapScreen: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000 //SETS UP HOW ZOOMed in we are at start
    var previousLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        //Do any additional setup after laoding the view, typically from a nib
    }
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        //call function always when we have authorization
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            //If services are ok, then setup location manager
            setupLocationManager()
            checkLocationAuthorization()
            //setup previous location at start, gets longitude and latitude
            //previousLocation = getCenterLocation(for: mapView)
        } else {
            // ALERT USER to allow services, or app will not work
        }
    }
    
    
    func checkLocationAuthorization() {
        //Basic authorization start up
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //Do map stuff when we have permission
            startTackingUserLocation()
        case .denied://when user hit "not allow", if denied we cannot pop up message
            //show alert instructing them how to turn onpermission
            break
        case .notDetermined://when user hasnt picked allow or not allow
            //request permission
            locationManager.requestWhenInUseAuthorization()
        case .restricted://user cannot use.."parental control"
            //show alert
            break
        case .authorizedAlways://when app is on background
            break
        }
    }
    
    
    func startTackingUserLocation() {
        mapView.showsUserLocation = true //littleBLUEDot
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation() //triggers deligate function
        previousLocation = getCenterLocation(for: mapView)
    }
    
    //for MapView, we pass in MKMapView..which in line 7
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        //get a latitude/longitude based on CENTER of map
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        //then create a CLLocation based on those values
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}


extension MapScreen: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //if authorization changes
        checkLocationAuthorization()
    }
}
//In order to use "reverse Geo Loca." need to set-up the MK map view delegate

extension MapScreen: MKMapViewDelegate {
    //Fisrt, we have the center of map with the pin, need to keep track of the center
    //if changes, keep track of that coordiante, to reverse geo-locate an address, get that address, and put that in our LABEL
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //Whenever the region did change, we will always have the center stored in CENTER
        let center = getCenterLocation(for: mapView)
        //Now need to initialize GEO based on LATITUDE and LONGITUDE
        let geoCoder = CLGeocoder()
        
        //to make sure preivousLocation has a value....self:to call members outside method
        guard let previousLocation = self.previousLocation else { return }
        
        
        
        //updating location whenever map moves, but we are limited by the number of times we can use this
        //need to set up a certain distance to call this function
        guard center.distance(from: previousLocation) > 50 else { return }
        //not call function geoCOder if doesnt meet requirement of >50 meters
        self.previousLocation = center
        //getting the location based on center's parameters
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            //this is all error checking to make sure we have everything
            if let _ = error {
                //inform user of error
                return
            }
            
            guard let placemark = placemarks?.first else {
                //alert
                return
            }
            
            //Thoroughfare= address
            let streetNumber = placemark.subThoroughfare ?? "" //show blank if no number is found
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber) \(streetName)" //display in label
            }
        }
    }
}
