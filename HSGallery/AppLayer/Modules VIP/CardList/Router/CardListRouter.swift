//
//  CardListRouter.swift
//  HSGallery
//
//  Created by YesVladess on 19.12.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import UIKit

class CardListRouter: NSObject, CardListRoutingLogic, CardListDataPassing {

    weak var transitionHandler : UITableViewController?
    weak var viewController: CardListTableViewController?
    var dataStore: CardListDataStore?
    
    // MARK: Routing
    
    func openCardInfoScreen() {
        
        guard let cardInfoVC = CardInfoModule.build() else {return}
        
        var destinationDS = cardInfoVC.router!.dataStore
        passViewModelToCardInfo(source: dataStore!, destination: &destinationDS)
        navigateToCardInfo(destination: cardInfoVC)
        
    }
    
    // MARK: Navigation
    
    func navigateToCardInfo(destination: CardInfoViewController) {
        
        transitionHandler?.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: Passing data
    
    func passViewModelToCardInfo(source: CardListDataStore, destination: inout CardInfoDataStore?) {
        
        destination?.cardInfo2 = source.cardInfo
    }
}

