//
//  NetworkController.swift
//  Safer_City
//
//  Created by Jesus Almazan on 1/23/19.
//  Copyright © 2019 Justino Almazan. All rights reserved.
//

import Foundation

public protocol NetworkController{
    func fetchCrimeData(crime: String, completionHandler: @escaping (CrimeData?, NetworkControllerError?) -> Void)
}

public struct CrimeData{
    var address: String
    var type: CrimeType
}

public enum CrimeType: String {
    
    case assault = "assault"
    case murder = "murder"
    case burglary = "burglary"
}

public enum NetworkControllerError: Error {
    case invalidURL(String)
    case invalidPayload(URL)
    case forwarded(Error)
}
