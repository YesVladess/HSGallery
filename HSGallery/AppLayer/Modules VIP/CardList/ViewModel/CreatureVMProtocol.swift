//
//  CardListViewModelProtocol.swift
//  HSGallery
//
//  Created by YesVladess on 24.12.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//
import UIKit

protocol CreatureVMProtocol {
    
    var cost: String { get set }
    var attack: String { get set }
    var health: String { get set }
    var rarity: String { get set }
    var text: String { get set }
    var img: URL { get set }
    
}
