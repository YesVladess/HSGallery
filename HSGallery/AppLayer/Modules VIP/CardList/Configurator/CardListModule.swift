//
//  CardListModule.swift
//  HSGallery
//
//  Created by YesVladess on 19.12.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import UIKit

class CardListModule {
    
    static func build() -> UINavigationController? {
        
        // Инициализируем тейбл вью контроллер, рутовый для навигейшен вью контроллера
        guard let viewController = CardListTableViewController.initFromDefaultStoryboard() else {
            return nil
        }
        
        // Инициализируем навигейшен вью контроллер, в который положим наш тейбл вью контроллер
        // И именно он будет рутовым контроллером для приложения
        let navigationController = UINavigationController.init(rootViewController: viewController)
        
        // Инициализируем остальные обязательные части модуля
        
        let router = CardListRouter()
        router.transitionHandler = viewController
        
        let presenter = CardListPresenter()
        presenter.view = viewController
        
        let interactor = CardListInteractor()
        interactor.presenter = presenter
        interactor.router = router
        
        viewController.interactor = interactor
        router.dataStore = interactor
        
        return navigationController
    }
}
