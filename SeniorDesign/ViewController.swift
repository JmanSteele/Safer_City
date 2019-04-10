import UIKit
import MapKit
import CoreLocation

class customPin: NSObject, MKAnnotation{
    var title: String?
    var subTitle: String?
    var coordinate: CLLocationCoordinate2D
    //var title: String?
    //var subTitle: String?
    
    init(title: String, subTitle: String, location:CLLocationCoordinate2D){
        self.title = title
        self.subTitle = subTitle
        self.coordinate = location
    }
    
}



class MapScreen: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var Crimes: UIButton!
    
 
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000 //SETS UP HOW ZOOMed in we are at start
    var previousLocation: CLLocation?
    
    let geoCoder = CLGeocoder()
    var directionsArray: [MKDirections] = [] //an array of directions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        startButton.layer.cornerRadius = startButton.frame.size.height/2
        checkLocationServices()
        //Do any additional setup after laoding the view, typically from a nib
        let open = OpenCrimeNetworkController()
        open.apiAccess()
        
    }
    func crimes(latitude: Double, longitude: Double, Types: String, crimeDates: String){
        //var subtitle: String?
        
        //var pin:customPin!
        
        let robery = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let crimePin = CrimeAnnotation(coordinate:robery, title:Types, subtitle:crimeDates)
        mapView.addAnnotation(crimePin)
        self.mapView.delegate = self
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKAnnotationView()
        guard let annotation = annotation as? CrimeAnnotation else {return nil}
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier){
            annotationView = dequedView
            
        } else{ annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
            
        }
        annotationView.image=UIImage(named: "Thief")
        annotationView.canShowCallout = true
        let paragraph = UILabel()
        paragraph.numberOfLines=0
        
        
        return annotationView
    }
    
    //func creatingPinImages(
    //create pin images for seperate crime
    /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     if annotation is MKUserLocation{
     return nil
     }
     var pinCrime: String!
     let annotationView = MKAnnotationView(annotation: pin, reuseIdentifier: title)
     
     switch Types{
     case ["Theft"]:
     pinCrime = "Thief"
     
     default:
     break
     }
     annotationView.image = UIImage(named: pinCrime)
     annotationView.canShowCallout = true
     return annotationView
     }*/

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
    func getDirections() {
        guard let location = locationManager.location?.coordinate else {
            // Inform user we don't have their current location
            return
        }
        
        let request = createDirectionsRequest(from: location)
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        
        directions.calculate { [unowned self] (response, error) in
            // Handle error if needed
            guard let response = response else { return } //if theres no response
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline) //the blue line connected in segments
                //resize the view of the map to fit the entire route in screen
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
      
    }

    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request{
        let destinationCoordinate = getCenterLocation(for: mapView).coordinate
        let startingLocation = MKPlacemark(coordinate: coordinate) //from my location
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request =  MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        request.requestsAlternateRoutes = true //multiple routes displayed
        
        return request
    }
    func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays) //refreshs the view, removes existing blue lines
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() } //multypling each value in array(segments in blue line) by 0 to remove previous direction
    }

    @IBAction func startButtonTapped(_ sender: UIButton) {
        getDirections()
    
    }
    
    @IBAction func crimesButtonTapped(_ sender: UIButton) {
        var i: Int=0
        for x in longarray{
            print (x, " ", latiarray[i], Types[i])
            
            crimes(latitude: x, longitude: latiarray[i], Types: Types[i], crimeDates: dates[i])
            i = i+1
        }
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
    //if changes, keep track of that coordiante, to reverse geo-locate an address, get that address, and
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //Whenever the region did change, we will always have the center stored in CENTER
        let center = getCenterLocation(for: mapView)
        //Now need to initialize GEO based on LATITUDE and LONGITUDE
        
        //to make sure preivousLocation has a value....self:to call members outside method
        guard let previousLocation = self.previousLocation else { return }
        
        //updating location whenever map moves, but we are limited by the number of times we can use this
        //need to set up a certain distance to call this function
        guard center.distance(from: previousLocation) > 50 else { return }
        //not call function geoCOder if doesnt meet requirement of >50 meters
        self.previousLocation = center
        
        geoCoder.cancelGeocode() //calcel previousrequest
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //Alert
                return
            }
            
            guard let placemark = placemarks?.first else {
                //Alert
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber) \(streetName)"
            }
        }
    }
    //set the style of the renderer
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        return renderer
    }
    //func creatingPinImages(
    //create pin images for seperate crime
    /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        var pinCrime: String = "Offense Occured"
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
        
        switch Types{
        case ["Theft"]:
            pinCrime = "Thief"
            
        default:
            break
        }
        annotationView.image = UIImage(named: pinCrime)
        annotationView.canShowCallout = true
        return annotationView
    }*/
}
