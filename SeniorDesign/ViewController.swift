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
    var userlatitude:  Double = 0
    var userlongitude: Double = 0
    var bool =  false
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000 //SETS UP HOW ZOOMed in we are at start
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
        open.apiAccess2()
        police_stations()
        
    }
    func crimes(latitude: Double, longitude: Double, Types: String, crimeDates: String){
        
        let robery = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let crimePin = CrimeAnnotation(coordinate:robery, title:Types, subtitle:crimeDates)
        mapView.addAnnotation(crimePin)
        self.mapView.delegate = self
    }
    //create images instead of using pins/markers
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKAnnotationView()
        guard let annotation = annotation as? CrimeAnnotation else {return nil}
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier){
            annotationView = dequedView
            
        } else{ annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
            
        }
        //change pins to thief image
        if(annotation.title == "police_station"){
            //let sub = annotation.subtitle.prefix(4)
            annotationView.image=UIImage(named: "station")
        }
        if(annotation.title == "THEFT"){
            //let sub = annotation.subtitle.prefix(4)
            
                annotationView.image=UIImage(named: "Thieff")
                
            
        }
        else if(annotation.title == "ASSAULT"){
            annotationView.image=UIImage(named: "assaultingf")}
        else if(annotation.title == "BATTERY"){
            annotationView.image=UIImage(named: "batteryf")}
        else if(annotation.title=="HOMICIDE"){
            annotationView.image=UIImage(named: "homicidef")
        }
        else if(annotation.title=="ROBBERY"){
            annotationView.image=UIImage(named: "robberyf")
        }
        else if(annotation.title=="OFFENSE INVOLVING CHILDREN"){
            annotationView.image=UIImage(named: "offensekidsf")
        }
        else if(annotation.title=="CRIM SEXUAL ASSAULT"){
            annotationView.image=UIImage(named: "sexassaultf")
        }
        else if(annotation.title=="SEX OFFENSE"){
            annotationView.image=UIImage(named: "sexoffensef")
        }
        else if(annotation.title=="STALKING"){
            annotationView.image=UIImage(named: "stalkingf")
        }
        else if(annotation.title=="ARSON"){
            annotationView.image=UIImage(named: "arsonf")
        }
        
        //fade images
        if(annotation.title == "THEFT2"){
            //let sub = annotation.subtitle.prefix(4)
            annotationView.image=UIImage(named: "Thief")
        }
        else if(annotation.title == "ASSAULT2"){
            annotationView.image=UIImage(named: "assaulting")}
        else if(annotation.title == "BATTERY2"){
            annotationView.image=UIImage(named: "battery")}
        else if(annotation.title=="HOMICIDE2"){
            annotationView.image=UIImage(named: "homicide")
        }
        else if(annotation.title=="ROBBERY2"){
            annotationView.image=UIImage(named: "robbery")
        }
        else if(annotation.title=="OFFENSE INVOLVING CHILDREN2"){
            annotationView.image=UIImage(named: "offensekids")
        }
        else if(annotation.title=="CRIM SEXUAL ASSAULT2"){
            annotationView.image=UIImage(named: "sexassault")
        }
        else if(annotation.title=="SEX OFFENSE2"){
            annotationView.image=UIImage(named: "sexoffense")
        }
        else if(annotation.title=="STALKING2"){
            annotationView.image=UIImage(named: "stalking")
        }
        else if(annotation.title=="ARSON2"){
            annotationView.image=UIImage(named: "arson")
        }
        //shows user the title and subtitle when they put their finger on the crime image
        
        annotationView.canShowCallout = true
        //format the viewing of title and subtitle
        let paragraph = UILabel()
        paragraph.numberOfLines=0
        
        return annotationView
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
            userlatitude = location.latitude
            userlongitude = location.longitude
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
        let x = destinationCoordinate.latitude
        let y = destinationCoordinate.longitude
        //print("start: ", userlatitude, ", ", userlongitude)
        //print("end: ", x, ", ", y)
        displayRouteCrimes(startlatitude: userlatitude, startlongitude: userlongitude, stoplatitude: x, stoplongitude: y)
        
        let request =  MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        request.requestsAlternateRoutes = true //multiple routes displayed
        
        return request
    }
    func displayRouteCrimes(startlatitude:Double, startlongitude: Double, stoplatitude: Double, stoplongitude: Double){
        let height: Double = abs(startlatitude - stoplatitude)
        let width: Double = abs(startlongitude - stoplongitude)
        
        var i: Int=0
        for y in longitudearray{
            if(abs(startlatitude - latitudearray[i]) <= height && abs(startlongitude - y) <= width){
                    crimes(latitude: latitudearray[i], longitude: y, Types: Types[i], crimeDates: dates[i])
            }
            i = i + 1
        }
        i = 0
        for y in longitudearray2{
            if(abs(startlatitude - latitudearray2[i]) <= height && abs(startlongitude - y) <= width){
                
                crimes(latitude: latitudearray2[i], longitude: y, Types: Types2[i], crimeDates: dates2[i])
            }
            i = i + 1
        }
    }
    func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays) //refreshs the view, removes existing blue lines
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() } //multypling each value in array(segments in blue line) by 0 to remove previous direction
    }

    @IBAction func startButtonTapped(_ sender: UIButton) {
        mapView.removeAnnotations(mapView.annotations)
        police_stations()
        getDirections()
    }
    
    @IBAction func crimesButtonTapped(_ sender: UIButton) {
        if(bool == true){
            mapView.removeAnnotations(mapView.annotations)
            police_stations()
            bool = false
        }
        
        else if(bool == false){
            var i: Int=0
            for y in longitudearray{
               // print (x, " ", latiarray[i], Types[i])
                crimes(latitude: latitudearray[i], longitude: y, Types: Types[i], crimeDates: dates[i])
                i = i+1
            }
            i=0
            for y in longitudearray2{
                // print (x, " ", latiarray[i], Types[i])
                
                crimes(latitude: latitudearray2[i], longitude: y, Types: Types2[i], crimeDates: dates2[i])
                i = i+1
            }
            bool = true
        }
    }
    func police_stations(){
        crimes(latitude: 41.8583725929 , longitude: -87.627356171, Types: "police_station", crimeDates:"station ")
        crimes(latitude: 41.7521368378 , longitude: -87.6442289066, Types: "police_station", crimeDates:"station ")
        crimes(latitude: 41.8735822883 , longitude: -87.705488126, Types: "police_station", crimeDates:"station ")
        crimes(latitude: 41.9740944511 , longitude: -87.7661488432, Types: "police_station", crimeDates:"station ")
        crimes(latitude: 41.9997634842 , longitude: -87.6713242922, Types: "police_station", crimeDates:"station ")
        crimes(latitude: 41.8018110912 , longitude: -87.6305601801, Types: "police_station", crimeDates:"station")
        crimes(latitude: 41.7796315359 , longitude: -87.6608870173, Types: "police_station", crimeDates:"station ")
        crimes(latitude: 41.9186088912 , longitude: -87.765574479, Types: "police_station", crimeDates:"station ")
        crimes(latitude: 41.8566845327 , longitude: -87.708381958, Types: "police_station", crimeDates:"station ")
        crimes(latitude: 41.8800834614 , longitude: -87.768199889, Types: "police_station", crimeDates:"station ")
        crimes(latitude: 41.7664308925 , longitude: -87.6057478606, Types: "police_station", crimeDates:"statio ")
        crimes(latitude: 41.9474004564 , longitude: -87.651512018, Types: "police_station", crimeDates:"station ")
        crimes(latitude: 41.8307016873 , longitude: -87.6233953459, Types: "police_station", crimeDates:"station ")
        crimes(latitude: 41.9211033246 , longitude: -87.6974518223, Types: "police_station", crimeDates:"station ")
        crimes(latitude: 41.778987189 , longitude: -87.7088638153, Types: "police_station", crimeDates:"station ")
        crimes(latitude: 41.7079332906 , longitude: -87.5683491228, Types: "police_station", crimeDates:"station ")
        crimes(latitude: 41.9795495131 , longitude: -87.6928445094, Types: "police_station", crimeDates:"station ")
        crimes(latitude: 41.9032416531 , longitude: -87.6433521393, Types: "police_station", crimeDates:"station ")
        crimes(latitude: 41.8629766244 , longitude: -87.6569725149, Types: "police_station", crimeDates:"station")
        crimes(latitude: 41.8373944311 , longitude: -87.6464077068, Types: "police_station", crimeDates:"station")
        crimes(latitude: 41.6914347795 , longitude: -87.6685203937, Types: "police_station", crimeDates:"station ")
        crimes(latitude: 41.6927233639 , longitude: -87.6045058667, Types: "police_station", crimeDates:"station ")
        crimes(latitude: 41.9660534171 , longitude: -87.728114561, Types: "police_station", crimeDates:"station")
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
}
