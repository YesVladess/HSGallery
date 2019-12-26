//
//  CardListModule.swift
//  HSGallery
//
//  Created by YesVladess on 19.12.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import UIKit

class CardListModule {
    
    static func build() -> CardListTableViewController? {
        
        guard let viewController = CardListTableViewController.initFromDefaultStoryboard() else {
            return nil
        }
        
        let router = CardListRouter()
        router.transitionHandler = viewController
        
        let presenter = CardListPresenter()
        presenter.view = viewController
        
        let interactor = CardListInteractor()
        interactor.presenter = presenter
        interactor.router = router
        
        viewController.interactor = interactor
        
        return viewController
    }
}
