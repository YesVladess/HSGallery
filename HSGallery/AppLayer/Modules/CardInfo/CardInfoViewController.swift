//
//  CardInfoViewController.swift
//  HSGallery
//
//  Created by YesVladess on 04.12.2019.
//  Copyright (c) 2019 YesVladess. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CardInfoDisplayLogic: class
{
  func displaySomething()
}

class CardInfoViewController: UIViewController, CardInfoDisplayLogic
{
  var interactor: CardInfoBusinessLogic?
  var router: (NSObjectProtocol & CardInfoRoutingLogic & CardInfoDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = CardInfoInteractor()
    let presenter = CardInfoPresenter()
    let router = CardInfoRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    textField.delegate = self
    doSomething()
  }
  
    @IBAction func pressButton(_ sender: UIButton) {
        
        let textFromTextField: String = textField.text ?? ""
        interactor?.getCard(textFromTextField)
        
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    func doSomething()
  {
//    let request = CardInfo.Something.Request()
//    interactor?.doSomething(request: request)
  }
  
  func displaySomething()
  {
    //nameTextField.text = viewModel.name
  }
}

extension CardInfoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
