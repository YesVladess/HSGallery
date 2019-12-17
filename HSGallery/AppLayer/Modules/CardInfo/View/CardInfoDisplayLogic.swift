//
//  CardInfoDisplayLogic.swift
//  HSGallery
//
//  Created by YesVladess on 17.12.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//
import UIKit

protocol CardInfoDisplayLogic: class {
    
    func displayCard(url: URL?, urlGold: URL?, cost: String, health: String, attack: String, rarity: String, text: String, flavor: String)
}
