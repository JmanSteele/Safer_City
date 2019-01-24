//
//  OpenCrimeNetworkController.swift
//  Safer_City
//
//  Created by Jesus Almazan on 1/23/19.
//  Copyright © 2019 Justino Almazan. All rights reserved.
//

import Foundation

final class OpenCrimeNetworkController: NetworkController{
    func fetchCrimeData(crime: String, completionHandler: @escaping (CrimeData?, NetworkControllerError?) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        let endpoint = "https://data.cityofchicago.org/resource/crimes.json"
        //this is the url we will use to access crime data
        
        let safeURLString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let endpointURL = URL(string: safeURLString!) else{
            completionHandler(nil, NetworkControllerError.invalidURL(safeURLString!))
            return
        }
        let dataTask = session.dataTask(with: endpointURL) { (data, response, error) in
            guard error == nil else{
                completionHandler(nil, NetworkControllerError.forwarded(error!))
                return
                //unwrapping error
            }
        }
    }
}
