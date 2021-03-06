//
//  CardListPresenter.swift
//  HSGallery
//
//  Created by YesVladess on 19.12.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//
import UIKit

class CardListPresenter {
    
    weak var view: CardListDisplayLogic?
    
    // MARK: Private formatting helpers
    
    private func formatCardCost(_ cost: Int?) -> String {
        
        if let myCost = cost { return "\(myCost) 💎" }
        else { return "no cost" }
    }
    
    private func formatCardHealth(_ health: Int?) -> String {
        if let myHealth = health { return "\(myHealth) ♥️" }
        else { return "no health" }
    }
    
    private func formatCardAttack(_ attack: Int?) -> String {
        if let myAttack = attack { return "\(myAttack) ⚔️" }
        else { return "no attack" }
    }
    
    private func formatCardRarity(_ rarity: String?) -> String {
        
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
        } else { return "no rarity" }
        
    }
    
    private func presentCardText(_ text: String?) -> String {
        if let carText = text {
            
            var result = carText.replacingOccurrences(of: "_", with: " ")
            result = result.replacingOccurrences(of: "<b>", with: "")
            result = result.replacingOccurrences(of: "</b>", with: "")
            result = result.replacingOccurrences(of: "\\n", with: " ")
            result = result.replacingOccurrences(of: "[x]", with: "")
            result = result.replacingOccurrences(of: "<i>", with: "")
            result = result.replacingOccurrences(of: "</i>", with: "")
            return result
        } else {
            return ""
        }
    }
    
    /**
     Метод собирает вью модель для типа карты 'Существо'
     */
    private func buildCreatureViewModels(cards: [CardModel]) -> [CreatureViewModelProtocol] {
        
        func buildViewModel(card: CardModel) -> CreatureViewModelProtocol {
            
            // Форматируем все параметры перед их отображением
            let url = card.img
            let cost = formatCardCost(card.cost)
            let health = formatCardHealth(card.health)
            let attack = formatCardAttack(card.attack)
            let rarity = formatCardRarity(card.rarity)
            let text = presentCardText(card.text)
            
            let viewModel = CreatureViewModel(cost: cost,
                                              attack: attack,
                                              health: health,
                                              rarity: rarity,
                                              text: text,
                                              img: url)
            return viewModel
        }
        
        // Массив вью моделей
        var viewModelsArray: [CreatureViewModelProtocol] = []
        
        for card in cards {
            
            // Собираем одну вью модель
            // Пока выкидываем всех не существ, модель есть только для них
            if card.type == "Minion" {
                let viewModel = buildViewModel(card: card)
                // И добавляем в массив
                viewModelsArray.append(viewModel)
            }
        }
        
        return viewModelsArray
    }
}

extension CardListPresenter: CardListPresentationLogic {
    
    func presentCardList(cards: [CardModel]) {
        
        let viewModels = buildCreatureViewModels(cards: cards)
        
        view?.displayCardList(cardList: viewModels)
    }
}

