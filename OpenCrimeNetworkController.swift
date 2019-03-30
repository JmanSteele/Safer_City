import UIKit

struct Crimes: Decodable {
    let id: Int?
    let caseNumber: String?
    let data: String?
    let block: String?
    let IUCR: String?
    let primaryType: String?
    let description: String?
    let locationDescription: String?
    let arrest: Bool?
    let domestic: Bool?
    let district: String?
    let ward: Int?
    let communityArea: String?
    let fbiCode: String?
    let xCoordinate: Int?
    let yCoordinate: Int?
    let year: Int?
    let updateOn: String?
    let latitude: Double?
    let longitude: Double?
    let Location: String?
}

final class OpenCrimeNetworkController: NetworkController{
    func apiAccess(){
        let jsonUrlString = "https://data.cityofchicago.org/resource/crimes.json"
        guard let url = URL(string: jsonUrlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //check error
            //check ok status 200
            
            guard let data = data else { return }
            
            do{
                let crime = try
                    JSONDecoder().decode(Crimes.self, from: data)
                print("ID:", crimes.id, "Crime:", crimes.primaryType)
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
        }
    }
}
