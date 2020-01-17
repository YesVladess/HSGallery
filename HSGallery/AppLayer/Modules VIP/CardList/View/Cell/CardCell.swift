//
//  CardTableViewCell.swift
//  HSGallery
//
//  Created by YesVladess on 22.12.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import UIKit

public class CardCell: UITableViewCell {
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var rarityLabel: UILabel!
    @IBOutlet weak var textLab: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private func fetchImage() {
        
        // Check that URL is set
        guard let url = imageURL else {
            cardImage = (UIImage(named: "card_back"))
            return // nothing to set
        }
        // Start the spinner to indicate we're about to start fetching/downloading the image
        spinner.isHidden = false
        spinner.startAnimating()
        
        
        // THINK: Вынести загрузку картинки в презентор?
        
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
                    DispatchQueue.main.async {
                        self?.cardImage = UIImage(named: "card_back")
                    }
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
            cardImageView.image = newValue
            
            cardImageView.backgroundColor = UIColor(#colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1))
            // Resize the view to properly fit the image's size
            cardImageView.sizeToFit()
            
            // We've succesfully set an image, stop the spinner
            spinner?.stopAnimating()
            spinner?.isHidden = true
        }
        get {
            // Return the imageView's current image
            return cardImageView.image
        }
    }
    
    func updateCellData(fromViewModel: CreatureViewModelProtocol) {
        
        // THINK: На Ipone SE rarityLabel не влезает при большом размере текста, как скейлить текст?
        
        if let viewModel = fromViewModel as? CreatureViewModel {
            imageURL = viewModel.img
            costLabel.text = viewModel.cost
            attackLabel.text = viewModel.attack
            healthLabel.text = viewModel.health
            rarityLabel.text = viewModel.rarity
            textLab.text = viewModel.text
        }
    }
}
