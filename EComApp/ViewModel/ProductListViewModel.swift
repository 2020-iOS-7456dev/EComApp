//
//  ProductListViewModel.swift
//  EComApp
//
//  Created by Raj Kadam on 04/06/20.
//  Copyright © 2020 Raj Kadam. All rights reserved.
//

import UIKit

class ProductListViewModel: NSObject {
    
    weak var delegate: ProductListProtocol?
    
    // MARK: - API Calling Method
       /**
        Check If Network is availabel if nor show  error message
        Fetch Data From API, And Save it To local Core Data
        
        
        */
    func getProductListAPI() {
        
        if !NetworkManager.isConnectedToInternet {
            
            BannerMessage.sharedManager.notificationBanner(msg: Constant.ErrorMessages.noInternetMessage, barColor: ColorName.errorRed)
            
            delegate?.failure()
            return
        }
        let urlString = APIUrl.baseUrl
        
        WebserviceHandler().get(url: urlString, parameter: nil) { (flag, responseData) in
            
            DispatchQueue.main.async(execute: {
                if flag {
                    
                }
                self.mapToProductListModel(response: responseData.data, urlResponse: responseData.response)
                
            })
        }
    }
    
    // MARK: - API Data Mapping Method
    /**
     Check If  data is availabel if not show  error message
     Map the data to Datamodel and then Save it to Core data
     
     
     */
    func mapToProductListModel(response: Data?, urlResponse: HTTPURLResponse? ) {
        guard let urlResponse = urlResponse else {
            return
            
        }
        guard let response = response else {
            delegate?.failure()
            return
            
        }
        if urlResponse.statusCode == 200 {
            
            do {
                let json = try? JSONSerialization.jsonObject(with: response, options: [])
                print(json!)
                
                let productListModel = try JSONDecoder().decode(ProductListModel.self, from: response)
                self.savetoCoreData(productList: productListModel)
                
            } catch let jsonError {
                print(jsonError)
                delegate?.failure()
            }
        } else {
            print("error code \(urlResponse.statusCode)")
            delegate?.failure()
        }
    }
    
    // MARK: - Save API Data to Local Method
    /**
     Clear the data from local DB
     And Then save new data .
     
     
     */
    func savetoCoreData(productList: ProductListModel) {
        
        try? CoreDataManager.deleteAllFromEntity(entity: "Category")
        try? CoreDataManager.deleteAllFromEntity(entity: "Product")

        CoreDataManager.saveAllProducts(productModel: productList)
     
        delegate?.success()
    }

    // MARK: - Get Products from CoreData Method
    /**
   
     Check if the products are available in DB
     If yes fetch all the product data
     */
    func getAllProducts() -> [Product]? {
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let fetchData = try? CoreDataManager.fetch(predicate: nil, sortDescriptor: sortDescriptor, entity: Product.description()) as? [Product]
        return fetchData
    }
    
}
