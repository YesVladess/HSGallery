//
//  CardListInteractor.swift
//  HSGallery
//
//  Created by YesVladess on 19.12.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import UIKit

class CardListInteractor: CardListDataStore {
    
    var presenter: CardListPresentationLogic?
    var router: CardListRoutingLogic?
    
    var cardList: [CardModel]?
    
    
}

extension CardListInteractor: CardListBusinessLogic {
    
    func getCardSet(_ set: String) {
        
        let myApi = HSGalleryRapidAPIService()
        
        myApi.getCardSet(named: set, completionHandler:
            { [unowned self] cards, error in
                if let errorDesc = error {
                    print(errorDesc)
                } else {
                    if let myCards = cards {
                        self.cardList = myCards
                        //print(myCards.debugDescription)
                        self.presenter?.presentCardList(cards: self.cardList!)
                    }
                }
        })
    }
}

