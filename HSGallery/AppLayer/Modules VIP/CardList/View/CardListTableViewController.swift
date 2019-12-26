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
    var viewModels = [CreatureVMProtocol]()
    private lazy var loadingQueue = OperationQueue()
    
    // MARK: - Creating methods
    
    static func initFromDefaultStoryboard() -> CardListTableViewController? {
        let storyboard = UIStoryboard(name: "CardListTableViewController", bundle: nil)
        
        guard let vc = storyboard.instantiateInitialViewController() as? CardListTableViewController else {
            return nil
        }
        
        return vc
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.prefetchDataSource = self

        // Зарегестрировали xib как новый тип ячейки для tableview
        let nib = UINib(nibName: "CardCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CardCell")
        
        tableView.separatorColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        //tableView.separatorStyle = .none
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.getCardSet("Classic")
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
        
        // Make sure it is the expected CardCell type
        guard let cardCell = cell as? CardCell else {
            return cell
        }
        
        cardCell.updateCellData(viewModel: viewModel)
        
        return cardCell
    }
    
//    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        return 350
//    }
    
}

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
    
    func displayCardList(cardList: [CreatureVMProtocol]) {
        
        viewModels = cardList
        tableView.reloadData()
    }
}
