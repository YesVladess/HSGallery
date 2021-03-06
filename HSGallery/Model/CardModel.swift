//
//  CardInfo.swift
//  HSGallery
//
//  Created by YesVladess on 04.12.2019.
//  Copyright (c) 2019 YesVladess. All rights reserved.
//

import Foundation

/**
 Модель, описывающая обьект одной карты.
 
 Вынесена из модулей,
 т.к. данная модель используется для загрузки данных
 на всех экранах приложения.
 
 Все optional свойства не являются обязательными для карты и могут отсуствовать
 Айди, имя, название сета и тип карты являются обязательными для любой карты
 */
public struct CardModel: Codable {
    
    let cardId: String
    let name: String
    let cardSet: String
    let type: String
    let faction: String?
    let rarity: String?
    let cost: Int?
    let attack: Int?
    let health: Int?
    let text: String?
    let flavor: String?
    let img: URL?
    let imgGold: URL?
    
    enum CodingKeys: String, CodingKey {
        case cardId = "cardId"
        case name = "name"
        case cardSet = "cardSet"
        case type = "type"
        case faction = "faction"
        case rarity = "rarity"
        case cost = "cost"
        case attack = "attack"
        case health = "health"
        case text = "text"
        case flavor = "flavor"
        case img = "img"
        case imgGold = "imgGold"
    }
    
}
