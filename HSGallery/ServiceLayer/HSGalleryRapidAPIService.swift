//
//  HSGalleryRapidAPIService.swift
//  HSGallery
//
//  Created by YesVladess on 11.12.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import Foundation
import Alamofire

/**
 Класс для работы с Api
 
 Иcпользует фреймворк Alamofire
 */
class HSGalleryRapidAPIService {
    
    // Массив хедеров с хостом и ключом для запросов к API
    let headers: HTTPHeaders = [
        "x-rapidapi-host": "omgvamp-hearthstone-v1.p.rapidapi.com",
        "x-rapidapi-key": "e26cba55dbmsh58c40a9a285a1b0p1e875ajsn8f9441fcaaf5"
    ]
    
    // Основной метод для апи запроса
    private func makeApiCall(request: String, _ completionHandler: @escaping ([CardModel]?, Error?) -> Void ) {
        
        AF.request(request, headers: headers)
        .responseJSON(queue: .global(qos: .userInitiated), completionHandler:
            { response in
                
                // Декодируем ответ в массив CardModel
                switch response.result {
                case .success:
                    if let jsonData = response.data {
                        let jsonDecoder = JSONDecoder()
                        do {
                            let cards = try jsonDecoder.decode([CardModel].self, from: jsonData)
                            DispatchQueue.main.async {
                                // После в главном потоке выполняем completionHandler
                                completionHandler(cards, nil)
                            }
                        } catch let error{
                            print(error.localizedDescription)
                            DispatchQueue.main.async {
                                // После в главном потоке выполняем completionHandler но прокидываем ошибку декодинга
                                completionHandler(nil, error)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    // После в главном потоке выполняем completionHandler но прокидываем ошибку респонса
                    completionHandler(nil, error)
                }
        })
    }
    
    /**
    Метод для получения информации по одной карте по имени или айди
    */
    func getSingleCard(byName cardNameOrId: String, completionHandler: @escaping ([CardModel]?, Error?) -> Void ) {
        
        // Для имен карт с пробелами в названии
        let requestName = cardNameOrId.replacingOccurrences(of: " ", with: "%2520")
        let request = "https://omgvamp-hearthstone-v1.p.rapidapi.com/cards/\(requestName)"
        makeApiCall(request: request, completionHandler)
    }
    
    /**
     Метод для получения сета карт (из одного дополнения)
     */
    func getCardSet(named setName: String, completionHandler: @escaping ([CardModel]?, Error?) -> Void ) {
        
        // Для названий сетов с пробелами в названии
        let requestName = setName.replacingOccurrences(of: " ", with: "%2520")
        let request = "https://omgvamp-hearthstone-v1.p.rapidapi.com/cards/sets/\(requestName)"
        makeApiCall(request: request, completionHandler)
    }
    
}
