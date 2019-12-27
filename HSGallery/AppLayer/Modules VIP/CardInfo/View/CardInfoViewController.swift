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

class CardInfoViewController: UIViewController {
    
    var interactor: CardInfoBusinessLogic?
    var router: (NSObjectProtocol & CardInfoRoutingLogic & CardInfoDataPassing)?
    
    var mainURL: URL?
    var secondURL: URL?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var flavorLabel: UILabel!
    @IBOutlet weak var rarityLabel: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // Model: The URL used to retrieve the image we're going to show
    var imageURL: URL? {
        didSet {
            // Reset the image to nil (to remove the prev. one)
            cardImage = nil
            
            fetchImage()
        }
    }
    
    /// Allows to set/get the UIImage shown in the `imageView`. It will also adapt/setup
    /// things to correctly match the controller's state. (i.e. adapt the `scrollView's`
    /// contentSize to properly enclose the new image size)
    private var cardImage: UIImage? {
        set {
            // Setup imageView's image to the new value
            imageView.image = newValue
            
            // Resize the view to properly fit the image's size
            imageView.sizeToFit()
            
            // We've succesfully set an image, stop the spinner
            spinner?.stopAnimating()
            spinner?.isHidden = true
        }
        get {
            // Return the imageView's current image
            return imageView.image
        }
    }
    
    // MARK: - Creating methods
    
    static func initFromDefaultStoryboard() -> CardInfoViewController? {
        let storyboard = UIStoryboard(name: "CardInfoViewController", bundle: nil)
        
        guard let vc = storyboard.instantiateInitialViewController() as? CardInfoViewController else {
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
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCardImageGestureRecognizer(imageView)
        imageView.isUserInteractionEnabled = true
        textField.delegate = self
    }
    
    // MARK: Helpers
    
    // TODO: Вынести в сервис!
    private func fetchImage() {
        
        // Check that URL is set
        guard let url = imageURL else {
            cardImage = (UIImage(named: "card_back"))
            return // nothing to set
        }
        
        // Start the spinner to indicate we're about to start fetching/downloading the image
        spinner.isHidden = false
        spinner.startAnimating()
        
        // Fetch image in the "background" (non-main queue).
        //
        // Note: Although we don't have a memory cycle for capturing `self`, we are using `[weak self]` because
        // the asynchronous operation could take some time to respond; by that time, the user might not be
        // waiting for it anymore (i.e. hit back or go somewhere else). In this case, we don't want to keep
        // `self` in the heap.
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            // Retrieve image data from the given URL
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 8.0
            sessionConfig.timeoutIntervalForResource = 8.0
            let session = URLSession(configuration: sessionConfig)
            session.dataTask(with: url) {
                (imageData, response, error) in
                
                if error != nil {
                    print(error!)
                    self?.cardImage = UIImage(named: "card_back")
                    return
                }
                // Set the image when the prev. async. operation finishes.
                //
                // Note: setting up `image` here is affecting/updating our UI. This must be done in the main
                // queue.
                DispatchQueue.main.async {
                    
                    // Note: This block of code might occur N seconds/minutes after we went fetching the data
                    // to the network. Because of this, the controller's `imageURL` might not be the same anymore
                    // (i.e. the caller/user changed it to something else), so we are checking that the url is
                    // still the same and therefore, the image is the one we currently want to show.
                    if url == self?.imageURL {
                        if let data = imageData {
                            if !(data.count == 0) {
                                self?.cardImage = UIImage(data: data)
                            } else {
                                self?.cardImage = UIImage(named: "card_back")
                            }
                        }
                    }
                }
            }.resume()
        }
    }
    
    // MARK: Gestures
    
    private func addCardImageGestureRecognizer(_ sender: AnyObject) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapImage(recognizer:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        sender.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func tapImage(recognizer: UITapGestureRecognizer) {
        
        // Make sure the gesture was successful
        guard recognizer.state == .ended else {
            print("Tap gesture cancelled/failed")
            return
        }
        if imageURL == mainURL {
            imageURL = secondURL
        } else {
            imageURL = mainURL
            
            // swapping URLS
            let tmp = mainURL
            mainURL = secondURL
            secondURL = tmp
        }
        
    }
    
    /// Whether or not the current view controller is shown on screen.
    private var viewControllerIsOnScreen: Bool {
        // We determine if we're on screen based on whether or not the controller's view
        // has a `window` set.
        return view.window != nil
    }
}


extension CardInfoViewController: CardInfoDisplayLogic {
    
    func displayCard(url: URL?, urlGold: URL?, cost: String, health: String, attack: String, rarity: String , text: String, flavor: String) {
        
        costLabel.text = cost
        healthLabel.text = health
        attackLabel.text = attack
        rarityLabel.text = rarity
        textLabel.text = text
        flavorLabel.text = flavor
        
        imageURL = url
        mainURL = url
        secondURL = urlGold
    }
}

extension CardInfoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let textFromTextField: String = textField.text ?? ""
        if textFromTextField != "" {
            interactor?.getCard(textFromTextField)
        }
    }
}
