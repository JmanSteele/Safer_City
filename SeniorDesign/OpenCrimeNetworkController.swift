import UIKit
import Foundation

struct Description: Decodable {
    let id: Int
    let caseNumber: String
    let date: String
    let block: String
    let IUCR: String
    let primaryType: String
    let descrip: String
    let locationDescription: String
    let arrest: Bool
    let domestic: Bool
    let district: String
    let ward: Int
    let communityArea: String
    let fbiCode: String
    let xCoordinate: Int
    let yCoordinate: Int
    let year: Int
    let updateOn: String
    let latitude: Double
    let longitude: Double
    let Location: String
}
var longitudearray: [Double] = []
var latitudearray: [Double] = []
var Types: [String] = []
var dates: [String] = []
var longitudearray2: [Double] = []
var latitudearray2: [Double] = []
var Types2: [String] = []
var dates2: [String] = []
var a: Int = 1

class OpenCrimeNetworkController{
    func apiAccess(){
        guard let url = URL(string: "https://data.cityofchicago.org/resource/3uz7-d32j.json") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            //check error
            //check ok status 200
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            //let open = MapScreen()
            
            
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                
                guard let jsonArray = jsonResponse as? [[String: Any]] else{
                    return
                }
                
                for dic in jsonArray{
                    var _latitude: Double
                    var _longitude: Double
                    var check = 1
                    //the guard lets help us make sure each set of data has the necessary variables otherwise we skip the variable
                    guard let primaryType = dic["_primary_decsription"] as? String else{
                        check = 0
                        continue
                    }
                    guard let latitude = dic["latitude"] as? String else{
                        check = 0
                        continue
                    }
                    guard let longitude = dic["longitude"] as? String else{
                        check = 0
                        continue
                    }
                    
                    guard let date = dic["date_of_occurrence"] as? String else{
                        check = 0
                        continue
                    }
                    
                    if primaryType == "CRIMINAL TRESPASS"{
                        check = 0
                    }
                    if primaryType == "CRIMINAL DAMAGE"{
                        check = 0
                    }
                    if primaryType == "NARCOTICS"{
                        check = 0
                    }
                    if primaryType == "PROSTITUTION"{
                        check = 0
                    }
                    if primaryType == "MOTOR VEHICLE THEFT"{
                        check = 0
                    }
                    if primaryType == "INTERFERENCE WITH PUBLIC OFFICER"{
                        check = 0
                    }

                    if primaryType == "GAMBLING"{
                        check = 0
                    }
                    if primaryType == "LIQUOR LAW VIOLATION"{
                        check = 0
                    }
                    if primaryType == "PUBLIC PEACE VIOLATION"{
                        check = 0
                    }
                    if primaryType == "DECEPTIVE PRACTICE"{
                        check = 0
                    }
                    if primaryType == "WEAPONS VIOLATION"{
                        check = 0
                    }
                    if primaryType == "OTHER OFFENSE"{
                        check = 0
                    }
                    
                    
                        if( check == 1){
                            _latitude = (latitude as NSString).doubleValue
                            _longitude = (longitude as NSString).doubleValue
                            
                        
                            Types.append(primaryType)
                            longitudearray.append(_longitude)
                            latitudearray.append(_latitude)
                            dates.append(date)
                            
                        }
                    
                       // print(jsonResponse)
                }
            
            }catch let parssingError{
                print("Error serializing json:", parssingError)
            }
        }
        task.resume()
    }
    
    func apiAccess2(){
        guard let url = URL(string: "https://data.cityofchicago.org/resource/crimes.json") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            //check error
            //check ok status 200
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            //let open = MapScreen()
            
            
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                
                guard let jsonArray = jsonResponse as? [[String: Any]] else{
                    return
                }
                
                for dic in jsonArray{
                    var _latitude: Double
                    var _longitude: Double
                    var check = 1
                    //the guard lets help us make sure each set of data has the necessary variables otherwise we skip the variable
                    guard let primaryType = dic["primary_type"] as? String else{
                        check = 0
                        continue
                    }
                    guard let latitude = dic["latitude"] as? String else{
                        check = 0
                        continue
                    }
                    guard let longitude = dic["longitude"] as? String else{
                        check = 0
                        continue
                    }
                    
                    guard let date = dic["date"] as? String else{
                        check = 0
                        continue
                    }
                    
                    if primaryType == "CRIMINAL TRESPASS"{
                        check = 0
                    }
                    if primaryType == "CRIMINAL DAMAGE"{
                        check = 0
                    }
                    if primaryType == "NARCOTICS"{
                        check = 0
                    }
                    if primaryType == "PROSTITUTION"{
                        check = 0
                    }
                    if primaryType == "MOTOR VEHICLE THEFT"{
                        check = 0
                    }
                    if primaryType == "INTERFERENCE WITH PUBLIC OFFICER"{
                        check = 0
                    }
                    
                    if primaryType == "GAMBLING"{
                        check = 0
                    }
                    if primaryType == "LIQUOR LAW VIOLATION"{
                        check = 0
                    }
                    if primaryType == "PUBLIC PEACE VIOLATION"{
                        check = 0
                    }
                    if primaryType == "DECEPTIVE PRACTICE"{
                        check = 0
                    }
                    if primaryType == "WEAPONS VIOLATION"{
                        check = 0
                    }
                    if primaryType == "OTHER OFFENSE"{
                        check = 0
                    }
                    
                    
                    if( check == 1){
                        _latitude = (latitude as NSString).doubleValue
                        _longitude = (longitude as NSString).doubleValue
                        
                        let primaryType = primaryType + "2"
                        Types2.append(primaryType)
                        longitudearray2.append(_longitude)
                        latitudearray2.append(_latitude)
                        dates2.append(date)
                    }
                    
                    // print(jsonResponse)
                }
                
            }catch let parssingError{
                print("Error serializing json:", parssingError)
            }
        }
        task.resume()
    }
}



