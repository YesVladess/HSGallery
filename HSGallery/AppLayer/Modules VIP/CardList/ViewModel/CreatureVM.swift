//
//  CardListModel.swift
//  HSGallery
//
//  Created by YesVladess on 19.12.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//
import UIKit

class CreatureVM : CreatureVMProtocol {
    
    var cost: String
    var attack: String
    var health: String
    var rarity: String
    var text: String
    var img: URL
    
    init(cost: String, attack: String, health: String, rarity: String, text: String, img: URL) {
        self.cost = cost
        self.attack = attack
        self.health = health
        self.rarity = rarity
        self.text = text
        self.img = img
    }
    
}
