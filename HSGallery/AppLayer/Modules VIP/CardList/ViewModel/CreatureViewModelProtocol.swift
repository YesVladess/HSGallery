//
//  CardListModel.swift
//  HSGallery
//
//  Created by YesVladess on 19.12.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//
import UIKit

protocol CreatureViewModelProtocol {
    
    var cost: String { get set }
    var attack: String { get set }
    var health: String { get set }
    var rarity: String { get set }
    var text: String { get set }
    var img: URL? { get set }
    
}

class CreatureVM : CreatureViewModelProtocol {
    
    var cost: String
    var attack: String
    var health: String
    var rarity: String
    var text: String
    var img: URL?
    
    init(cost: String, attack: String, health: String, rarity: String, text: String, img: URL?) {
        self.cost = cost
        self.attack = attack
        self.health = health
        self.rarity = rarity
        self.text = text
        self.img = img
    }
    
}
