//
//  CardInfoModule.swift
//  HSGallery
//
//  Created by YesVladess on 17.12.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import UIKit

class CardInfoModule {
    
    static func build() -> CardInfoViewController? {
        
        guard let viewController = CardInfoViewController.initFromDefaultStoryboard() else {
            return nil
        }
        
        let router = CardInfoRouter()
        router.transitionHandler = viewController
        
        let presenter = CardInfoPresenter()
        presenter.view = viewController
        
        let interactor = CardInfoInteractor()
        interactor.presenter = presenter
        interactor.router = router
        
        viewController.interactor = interactor
        // Странная связь
        viewController.router = router
        // Тоже странная
        router.dataStore = interactor
        
        return viewController
    }
}
