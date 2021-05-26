//
//  FiftyTwoCardFrenchSuiteCardImageFactory.swift
//  Cards
//
//  Created by Luke Van In on 2021/05/26.
//

import SwiftUI

import Deck


struct FiftyTwoCardFrenchSuiteCardImageFactory: CardImageFactory {
    
    typealias Card = FiftyTwoCardFrenchSuiteDeck.Card
    
    let path: String?
    
    func image(for card: Card, size: CGSize) throws -> UIImage {
        let name = assetPath(for: card)
        guard let image = UIImage(named: name) else {
            throw CardImageFactoryError.cannotLoadCard
        }
        return image
    }
    
    private func assetPath(for card: Card) -> String {
        let name = assetName(for: card)
        return "\(path ?? "")\(name)"
    }
    
    private func assetName(for card: Card) -> String {
        let suitePrefix = card.suite.name.prefix(1)
        let rankPrefix = String(card.rank.symbol)
        return "\(suitePrefix)\(rankPrefix)".lowercased()
    }
}

extension FiftyTwoCardFrenchSuiteCardImageFactory {
    
    static var standard = FiftyTwoCardFrenchSuiteCardImageFactory(path: "kenney/")
}
