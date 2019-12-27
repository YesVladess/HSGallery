//
//  ImageServiceFetcher.swift
//  HSGallery
//
//  Created by YesVladess on 27.12.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import Foundation
import UIKit

public class ImageFetcherService {
    
    // MARK: Helpers
    func fetchImage(fromURL imageURL: URL?, forImage image: inout UIImage?) {
        
        var myImage = image
        
        // Check that URL is set
        guard let url = imageURL else {
            myImage = UIImage(named: "card_back")
            return
        }
        
        // Fetch image in the "background" (non-main queue).
        //
        // Note: Although we don't have a memory cycle for capturing `self`, we are using `[weak self]` because
        // the asynchronous operation could take some time to respond; by that time, the user might not be
        // waiting for it anymore (i.e. hit back or go somewhere else). In this case, we don't want to keep
        // `self` in the heap.
        DispatchQueue.global(qos: .userInitiated).async {
            
            // Retrieve image data from the given URL
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 10.0
            sessionConfig.timeoutIntervalForResource = 10.0
            let session = URLSession(configuration: sessionConfig)
            session.dataTask(with: url) {
                (imageData, response, error) in
                
                if error != nil {
                    print(error!)
                    DispatchQueue.main.async {
                        myImage = UIImage(named: "card_back")
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
                    if url == imageURL {
                                if let data = imageData {
                                    if !(data.count == 0) {
                                        myImage = UIImage(data: data)
                                    } else {
                                        myImage = UIImage(named: "card_back")
                                    }
                                }
                            }
                        }
                    }.resume()
        }
        
        image = myImage
    }
    
}
