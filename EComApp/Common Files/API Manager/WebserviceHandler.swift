//
//  WebserviceHandler.swift
//  EComApp
//
//  Created by Raj Kadam on 04/06/20.
//  Copyright © 2020 Raj Kadam. All rights reserved.
//

import Foundation
import Alamofire

class WebserviceHandler {

    
    // MARK: - Get Request Method
    /**
     This method creates get Request and make API call
     */
    func get(url: String, parameter: [String: AnyObject]?, completion: @escaping (Bool, AFDataResponse<Any>) -> ()) {

        let request = AF.request(url, method: .get, parameters: parameter)
    
        makeAPICall(request: request, completion: completion)
        
    }

      // MARK: - Make API call Method
        /**
         This method make call to server and fetch data
         */
     func makeAPICall(request: DataRequest, completion: @escaping (Bool, AFDataResponse<Any>) -> ()) {
       
         request.validate()
         .responseJSON { responseData in
                 guard responseData.error == nil else {
                     // got an error in getting the data, need to handle it
                     
                     print(responseData.error!)
                    return completion(false, responseData)
                 }
             
            if responseData.value != nil {
                return completion(true, responseData)
            } else {
                return completion(false, responseData)
            }
             
         }
     }

}
