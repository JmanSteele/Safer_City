import UIKit
import Foundation

struct Description: Decodable {
    let id: Int
    let caseNumber: String
    let data: String
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
                    
                    guard let year = dic["year"] as? String else{
                        check = 0
                        continue
                    }
                    let year2 = (year as NSString).intValue
                    
                    
                    
                    if(year2 >= 2018){
                        if( check == 1){
                            lati = (latitude as NSString).doubleValue
                            long = (longitude as NSString).doubleValue
                        
                            Types.append(primaryType)
                            longarray.append(lati)
                            latiarray.append(long)
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



