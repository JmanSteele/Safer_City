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
var longarray: [Double] = []
var latiarray: [Double] = []
var Types: [String] = []
var dates: [String] = []
var a: Int = 1

class OpenCrimeNetworkController{
    func apiAccess(){
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
                   
                    var lati: Double
                    var long: Double
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
                    
                    guard let year = dic["year"] as? String else{
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
                    if primaryType == "NON-CRIMINAL"{
                        check = 0
                    }
                    if primaryType == "GAMBLING"{
                        check = 0
                    }
                    if primaryType == "LIQUOR LAW VIOLATION"{
                        check = 0
                    }
                    let year2 = (year as NSString).intValue
                    
                    
                    
                    if(year2 >= year2-1){
                        if( check == 1){
                            lati = (latitude as NSString).doubleValue
                            long = (longitude as NSString).doubleValue
                            
                        
                            Types.append(primaryType)
                            longarray.append(lati)
                            latiarray.append(long)
                            dates.append(date)
                        }
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



