//
//  CardInfoPresenter.swift
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

class CardInfoPresenter {
    
    weak var view: CardInfoDisplayLogic?
    
    private func getCardUrl(_ url: URL?) -> URL? {
        if let myUrl = url {
            return myUrl
        }
        // TODO: FIXME!!!!!!!!
        else { return nil }
    }
    
    private func presentCardCost(_ cost: Int?) -> String {
        if let myCost = cost {
            return "\(myCost) 💎"
        } else {
            return "no cost"
        }
    }
    
    private func presentCardHealth(_ health: Int?) -> String {
        if let myHealth = health {
            return "\(myHealth) ♥️"
        } else {
            return "no health"
        }
    }
    
    private func presentCardAttack(_ attack: Int?) -> String {
        if let myAttack = attack {
            return "\(myAttack) ⚔️"
        } else {
            return "no attack"
        }
    }
    
    private func presentCardRarity(_ rarity: String?) -> String {
        
        if let cardRarity = rarity {
            switch cardRarity {
            case "Free":
                return "\(cardRarity)"
            case "Common":
                return "⚪️ \(cardRarity) ⚪️"
            case "Rare":
                return "🔷 \(cardRarity) 🔷"
            case "Epic":
                return "🟣 \(cardRarity) 🟣"
            case "Legendary":
                return "🔶 \(cardRarity) 🔶"
            default:
                return ""
            }
        } else { return "No RARITY????" }
        
    }
    
    private func presentCardText(_ text: String?) -> String {
        if let carText = text {
            
            var result = carText.replacingOccurrences(of: "_", with: " ")
            result = result.replacingOccurrences(of: "<b>", with: "")
            result = result.replacingOccurrences(of: "</b>", with: "")
            result = result.replacingOccurrences(of: "\\n", with: " ")
            return result
        } else {
            return "No card text"
        }
    }
    
    private func presentCardFlavor(_ flavor: String?) -> String {
        if let cardFlavor = flavor {
            return cardFlavor
        }
        else {
            return "No flavor"
        }
    }
}

extension CardInfoPresenter: CardInfoPresentationLogic {
    
    func presentCard(card: CardModel) {
        
        // Formatting all parameters before displaying them
        let url = getCardUrl(card.img)
        let urlGold = card.imgGold
        let cost = presentCardCost(card.cost)
        let health = presentCardHealth(card.health)
        let attack = presentCardAttack(card.attack)
        let rarity = presentCardRarity(card.rarity)
        let text = presentCardText(card.text)
        let flavor = presentCardFlavor(card.flavor)
        
        view?.displayCard(url: url, urlGold: urlGold, cost: cost, health: health, attack: attack, rarity: rarity, text: text, flavor: flavor)
    }
}