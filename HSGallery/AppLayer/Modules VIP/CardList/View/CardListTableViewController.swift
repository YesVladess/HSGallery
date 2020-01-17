//
//  CardListTableViewController.swift
//  HSGallery
//
//  Created by YesVladess on 19.12.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import UIKit

class CardListTableViewController: UITableViewController {
    
    var interactor: CardListBusinessLogic?
    var router: (NSObjectProtocol & CardListRoutingLogic & CardListDataPassing)?
    var viewModels = [CreatureViewModelProtocol]()
    
    // MARK: - Creating methods
    
    static func initFromDefaultStoryboard() -> CardListTableViewController? {
        
        let storyboard = UIStoryboard(name: "CardListTableViewController", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? CardListTableViewController else {
            return nil
        }
        return vc
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Настройка NavBar
        self.view.backgroundColor = UIColor.gray
        self.navigationItem.title = "All Cards"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        // Стали делегатом UITableViewDataSourcePrefetching
        // Для UITableViewDelegate, UITableViewDataSource мы уже делегаты,
        // т.к. используется UITableViewController
        tableView.prefetchDataSource = self
        // Зарегистрировали xib как новый тип ячейки для tableview
        let nib = UINib(nibName: "CardCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CardCell")
        // Настройка сепаратора
        tableView.separatorColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        tableView.separatorStyle = .singleLine
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // THINK: Переделать?
        // Если мы не возвращаемся из дет. инфо (тогда грузить карты заново не нужно)
        // Запрашиваем у интерактора сет карт
        if self.isMovingToParent {
            interactor?.getCardSet("Classic")
        }
    }
}

extension CardListTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewModel = viewModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath)
        // Проверяем, что это ячейка нужного нам типа
        guard let cardCell = cell as? CardCell else {
            return cell
        }
//        обновляем ячейку согласно вьюмодели
        cardCell.updateCellData(fromViewModel: viewModel)
        
        return cardCell
    }
    
//    Высота ячейки задается хардкодом
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
}

extension CardListTableViewController {
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Если для ячейки есть вью модель, достаем ее
        guard indexPath.row < viewModels.count else { return }
        let viewModel = viewModels[indexPath.row]
        
        interactor?.openCardDetailInfo(viewModel: viewModel)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
}

// THINK: Пока не получилось имплементировать
extension CardListTableViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
//            if let _ = loadingOperations[indexPath] { return }
//            if let dataLoader = dataStore.loadImage(at: indexPath.row) {
//                loadingQueue.addOperation(dataLoader)
//                loadingOperations[indexPath] = dataLoader
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
//            if let dataLoader = loadingOperations[indexPath] {
//                dataLoader.cancel()
//                loadingOperations.removeValue(forKey: indexPath)
//            }
//        }
    }
    
}

extension CardListTableViewController: CardListDisplayLogic {
    
    /// Показать сет карт
    func displayCardList(cardList: [CreatureViewModelProtocol]) {
        
        viewModels = cardList
        tableView.reloadData()
    }
}
