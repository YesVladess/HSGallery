//
//  HSGalleryRapidAPIService.swift
//  HSGallery
//
//  Created by YesVladess on 11.12.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import Foundation
import Alamofire

class HSGalleryRapidAPIService {
    
    // Credentials for api requests
    let headers: HTTPHeaders = [
        "x-rapidapi-host": "omgvamp-hearthstone-v1.p.rapidapi.com",
        "x-rapidapi-key": "e26cba55dbmsh58c40a9a285a1b0p1e875ajsn8f9441fcaaf5"
    ]
    
    func getCardSet(named setName: String, completionHandler: @escaping ([CardModel]?, Error?) -> Void ) {
        
        // Для имен карт с пробелами в названии
        let requestName = setName.replacingOccurrences(of: " ", with: "%2520")
        
        AF.request("https://omgvamp-hearthstone-v1.p.rapidapi.com/cards/sets/\(requestName)", headers: headers)
        .responseJSON(queue: .global(qos: .userInitiated), completionHandler:
            { response in
                
                //debugPrint(response)
                // Checking response status
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("successful response")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                
                // Decoding Json into an array of CardInfo structs and executing completionHandler on main thread after
                switch response.result {
                case .success:
                    if let jsonData = response.data {
                        let jsonDecoder = JSONDecoder()
                        do {
                            let cards = try jsonDecoder.decode([CardModel].self, from: jsonData)
                            DispatchQueue.main.async {
                                completionHandler(cards, nil)
                            }
                        } catch let error{
                            print(error.localizedDescription)
                            DispatchQueue.main.async {
                                completionHandler(nil, error)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(nil, error)
                }
        })
    }
    
    // Get single card information
    func getSingleCard(byName cardName: String, completionHandler: @escaping ([CardModel]?, Error?) -> Void ) {
        
        // Для имен карт с пробелами в названии
        let requestName = cardName.replacingOccurrences(of: " ", with: "%2520")
        
        AF.request("https://omgvamp-hearthstone-v1.p.rapidapi.com/cards/\(requestName)", headers: headers)
            .responseJSON(queue: .global(qos: .userInitiated), completionHandler:
                { response in
                    
                    //debugPrint(response)
                    // Checking response status
                    if let status = response.response?.statusCode {
                        switch(status){
                        case 200:
                            print("successful response")
                        default:
                            print("error with response status: \(status)")
                        }
                    }
                    
                    // Decoding Json into an array of CardInfo structs and executing completionHandler on main thread after
                    switch response.result {
                    case .success:
                        if let jsonData = response.data {
                            let jsonDecoder = JSONDecoder()
                            do {
                                let cards = try jsonDecoder.decode([CardModel].self, from: jsonData)
                                DispatchQueue.main.async {
                                    completionHandler(cards, nil)
                                }
                            } catch let error{
                                print(error.localizedDescription)
                                DispatchQueue.main.async {
                                    completionHandler(nil, error)
                                }
                            }
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        completionHandler(nil, error)
                    }
            })
    }
    
}
